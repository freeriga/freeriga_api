class RolifyCreateTerminalRoles < ActiveRecord::Migration[6.0]
  def change
    create_table(:terminal_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:terminals_terminal_roles, :id => false) do |t|
      t.references :terminal
      t.references :terminal_role
    end
    
    add_index(:terminal_roles, [ :name, :resource_type, :resource_id ])
    add_index(:terminals_terminal_roles, [ :terminal_id, :terminal_role_id ], name: :ttri)
  end
end
