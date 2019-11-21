class TerminalSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :email
  belongs_to :location
end
