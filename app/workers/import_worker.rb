class ImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  attr_reader :task, :media

  def perform(task_id)
    @task = Task.find(task_id)
    task.in_progress
    TasksChannel.task_updated(task)

    begin
      @media = YoutubeDL::Media.new(task.url, uuid: task.media_uuid)
      media.playlist? ? import_playlist : import_single
      task.completed
    rescue YoutubeDL::ImportError
      task.failed
    ensure
      TasksChannel.task_updated(task)
    end
  end

  private

  def import_playlist
    media.playlist_urls.each_slice(Sidekiq.options[:concurrency]) do |batch|
      tasks = batch.map do |url|
        md = YoutubeDL::Media.new(url)
        Task.new(
          status: :queued,
          media_uuid: md.uuid,
          url: url,
          title: md.title,
          destination_directory: task.destination_directory
        )
      end

      Task.import(tasks)
      tasks = Task.where(url: media.playlist_urls)
      tasks.find_each { |task| TasksChannel.task_created(task) }
      Sidekiq::Client.push_bulk(
        'class' => ImportWorker,
        'args' => tasks.map(&:id).map { |id| [id] }
      )
    end

    media.clear_tmp_dir
  end

  def import_single
    media.import(outdir: "#{Config.import_root}/#{task.destination_directory}")
    UpdateFileTags.call(Config.import_root)
  end
end
