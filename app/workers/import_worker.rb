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
    media.playlist_urls.each do |url|
      md = YoutubeDL::Media.new(url)
      tsk = Task.create!(
        media_uuid: md.uuid,
        url: url,
        title: md.title,
        destination_directory: task.destination_directory
      )

      TasksChannel.task_created(tsk)
      ImportWorker.perform_async(tsk.id)
    end
  end

  def import_single
    media.import(outdir: "#{Config.import_root}/#{task.destination_directory}")
    UpdateFileTags.call(Config.import_root)
  end
end
