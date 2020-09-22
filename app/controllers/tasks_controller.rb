class TasksController < ApplicationController
  def create
    url = params[:url]
    destination_directory = destination_param

    if url.nil? || url.empty?
      return json_response(
        { error: "Url cannot be empty" },
        success: false
      )
    end

    if destination_directory.nil? || destination_directory.empty?
      return json_response(
        { error: "Destination cannot be empty" },
        success: false
      )
    end

    if Task.in_progress.count == 5
      return json_response(
        { error: "Max number of tasks has been reached" },
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

  private
  def destination_param
    params[:destination_directory].split('/').map(&:strip).join('/')
  end
end