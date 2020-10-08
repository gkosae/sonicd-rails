class ImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(task_id)
    task = Task.find(task_id)
    task.in_progress
    TasksChannel.task_updated(task)
    
    begin
      YoutubeDL::Media.new(task.url).import(
        outdir: "#{Config.import_root}/#{task.destination_directory}"
      )
      
      task.completed
    rescue YoutubeDL::ImportError
      task.failed
    ensure
      TasksChannel.task_updated(task)
    end
  end
end