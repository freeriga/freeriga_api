class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :username, :colour, :summary_en, :location_id, :user_location_id, :summary_lv, :summary_ru, :status, :created_at, :updated_at
  belongs_to :location
  belongs_to :user_location
  has_many :comments
  attribute :image_box do |obj|
    if obj.image.attached?
      obj.image.variant(resize_to_limit: [350, 350]).processed.service_url
    else
      nil
    end
  end
  attribute :image_url do |obj|
    if obj.image.attached?
      obj.image.service_url
    else
      nil
    end
  end    
end
