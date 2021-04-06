class MonitorTasksWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    each_hung_task do |task|
      task.failed
      TasksChannel.task_updated(task)
    end
  end

  private

  def each_hung_task
    Task.in_progress.updated_before(2.hours.ago).find_each do |task|
      yield task
    end
  end
end
