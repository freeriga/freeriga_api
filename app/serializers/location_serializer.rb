class LocationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :nickname
  belongs_to :quarter
end
