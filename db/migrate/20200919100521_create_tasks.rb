class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :destination_directory
      t.string :url
      t.string :status
      t.timestamps
    end
  end
end
