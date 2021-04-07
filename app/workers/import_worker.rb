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
    rescue YoutubeDL::ImportError
      task.failed
    ensure
      TasksChannel.task_updated(task)
    end

    task.completed
  end

  private

  def import_playlist
    tasks = media.playlist_urls.map do |url|
      md = YoutubeDL::Media.new(url)
      Task.new(
        media_uuid: md.uuid,
        url: url,
        title: md.title,
        destination_directory: task.destination_directory
      )
    end

    Task.import(tasks)
    task_ids = Task.where(url: media.playlist_urls).ids
    Sidekiq::Client.push_bulk(
      'class' => ImportWorker,
      'args' => task_ids.map { |id| [id] }
    )
  end

  def import_single
    media.import(outdir: "#{Config.import_root}/#{task.destination_directory}")
    UpdateFileTags.call(Config.import_root)
  end
end
