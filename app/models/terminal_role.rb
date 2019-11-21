class TerminalRole < ApplicationRecord
has_and_belongs_to_many :terminals, :join_table => :terminals_terminal_roles


belongs_to :resource,
           :polymorphic => true,
           :optional => true


validates :resource_type,
          :inclusion => { :in => Rolify.resource_types },
          :allow_nil => true

scopify
end
