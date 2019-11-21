class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :username, :colour, :summary_en, :location_id, :user_location_id, :summary_lv, :summary_ru, :status, :created_at, :updated_at
  belongs_to :location
  belongs_to :user_location
  has_many :comments
end
