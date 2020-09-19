class TasksController < ApplicationController
  def create
    url = params[:url]
    destination_directory = params[:destination_directory]

    if url.nil? || url.empty?
      return json_response(
        { error: "url cannot be empty" },
        success: false
      )
    end

    media = YoutubeDL::Media.new(url)

    unless media.valid?
      return json_response(
        { error: "'#{url}' is either invalid or not supported" },
        success: false
      )
    end

    task = Task.create!(
      url: url,
      title: media.title,
      destination_directory: destination_directory
    )

    ImportWorker.perform_async(task.id)

    json_response(
      task: TaskSerializer.
        new(task).
        serializable_hash
    )
  end

  def index
    tasks = Task.order(created_at: :desc).page(1).per_page(5)
    json_response(
      tasks: TaskSerializer.
        new(tasks).
        serializable_hash
    )
  end
end