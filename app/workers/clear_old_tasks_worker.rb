class ClearOldTasksWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    Task.created_before(1.day.ago).delete_all
  end
end
