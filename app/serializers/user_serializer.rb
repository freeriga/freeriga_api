class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :nickname, :email, :location_id
  belongs_to :location
  attribute :quarter_id do |obj|
    obj.location.quarter_id
  end
end
