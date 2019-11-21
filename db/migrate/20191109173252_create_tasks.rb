class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.references :location, null: false, foreign_key: true
      t.string :username
      t.string :colour
      t.integer :status

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Task.create_translation_table! summary: :text
      end

      dir.down do
        Task.drop_translation_table!
      end
    end
  end
end
