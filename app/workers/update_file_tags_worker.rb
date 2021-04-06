class UpdateFileTagsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    UpdateFileTags.call(Config.import_root, incremental: false)
  end
end
