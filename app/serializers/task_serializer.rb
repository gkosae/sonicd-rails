class TaskSerializer
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def serializable_hash
    if @resource.respond_to?(:each)
      return collection(@resource)
    else
      return single(@resource)
    end
  end

  private
  def single(task)
    {
      id: task.id,
      title: task.title,
      status: task.status,
      url: task.url,
      destination_directory: task.destination_directory,
      created_at: task.created_at
    }
  end

  def collection(tasks)
    tasks.map{|task| single(task)}
  end
end