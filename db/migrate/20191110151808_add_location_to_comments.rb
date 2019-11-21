class AddLocationToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :location_id, :integer
  end
end
