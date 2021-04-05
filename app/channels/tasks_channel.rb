class TasksChannel < ApplicationCable::Channel
  module Events
    CREATED = 'created'.freeze
    UPDATED = 'updated'.freeze
  end

  def subscribed
    stream_from 'tasks_channel'
  end

  class << self
    def task_created(task)
      broadcast(event: Events::CREATED, task: task)
    end

    def task_updated(task)
      broadcast(event: Events::UPDATED, task: task)
    end

    def broadcast(event:, task:)
      ActionCable.server.broadcast(
        'tasks_channel',
        message: {
          event: event,
          task: TaskSerializer
            .new(task)
            .serializable_hash
        }
      )
    end
  end
end
