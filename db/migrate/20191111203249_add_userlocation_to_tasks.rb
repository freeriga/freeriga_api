class AddUserlocationToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :user_location_id, :integer
    add_index :tasks, :user_location_id
  end
end
