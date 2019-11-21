class QuarterSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :address
end
