class AddUserToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :user_id, :integer
    add_column :comments, :user_id, :integer
    add_index :tasks, :user_id
    add_index :comments, :user_id
  end
end
