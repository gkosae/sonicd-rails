class AddMediaUuidToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :media_uuid, :string
  end
end
