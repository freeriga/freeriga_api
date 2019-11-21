class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.references :quarter, null: false, foreign_key: true
      t.string :name
      t.string :nickname

      t.timestamps
    end
  end
end
