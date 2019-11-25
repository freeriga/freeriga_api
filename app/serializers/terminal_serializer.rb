class TerminalSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :email, :location_id
  attribute :quarter_id do |obj|
    obj.location.quarter_id
  end
  belongs_to :location
end
