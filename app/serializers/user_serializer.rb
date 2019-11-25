class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :nickname, :email, :location_id
  belongs_to :location
  attribute :quarter_id do |obj|
    obj.location.quarter_id
  end
  attribute :avatar_icon do |obj|
    begin
      if obj.avatar.attached?
        obj.avatar.variant(resize_to_limit: [100, 100]).processed.service_url
      else
        nil
      end
    rescue ActiveStorage::FileNotFoundError
      'https://cdn0.iconfinder.com/data/icons/interface-set-vol-2/50/No_data_No_info_Missing-512.png'
    end
  end
  attribute :avatar_url do |obj|
    if obj.avatar.attached?
      obj.avatar.service_url
    else
      nil
    end
  end  
end
