class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :item, polymorphic: true, null: false
      t.string :username
      t.string :colour, null: false, default: '#000'

      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Comment.create_translation_table! body: :text
      end

      dir.down do
        Comment.drop_translation_table!
      end
    end
  end
end
