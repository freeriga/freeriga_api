class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.references :item, polymorphic: true, null: false

      t.timestamps
    end
  end
end
