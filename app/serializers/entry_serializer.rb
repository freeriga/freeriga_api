class EntrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :item_type, :item_id, :created_at, :updated_at
  attribute :text do |obj|
    if obj.item.class == Task
      obj.item.summary
    elsif obj.item.class == Comment
      obj.item.body
    end
  end
  attribute :translations_count do |obj|
    if obj.item.class == Task
      obj.item.summary_translations.size
    else
      obj.item.body_translations.size
    end
  end
  attribute :translations_hash do |obj|
    if obj.item.class == Task
      obj.item.summary_translations
    else
      obj.item.body_translations
    end
  end 
  # attribute :lv do |obj|
  #   if obj.item.class == Task
  #     obj.item.summary_lv
  #   elsif obj.item.class == Comment
  #     obj.item.item.name
  #   end
  # end
  # attribute :en do |obj|
  #   if obj.item.class == Task
  #     obj.item.summary_en
  #   elsif obj.item.class == Comment
  #     obj.item.item.name
  #   end
  # end
  # attribute :ru do |obj|
  #   if obj.item.class == Task
  #     obj.item.summary_ru
  #   elsif obj.item.class == Comment
  #     obj.item.item.name
  #   end
  # end  
  attribute :username do |obj|
    obj.item.username
  end
  attribute :colour do |obj|
    obj.item.colour
  end
  attribute :size do |obj|
    'is-' + [3,4,5,6,7].sample.to_s
  end
  attributes :user_location_id do |obj|
    if obj.item.respond_to?('user_location_id')
      obj.item.user_location_id
    else
      obj.item.location_id
    end
  end
  attributes :user_location_name do |obj|
    if obj.item.respond_to?('user_location_id')
      obj.item.user_location.name
    else
      obj.item.location.name
    end
  end  
  attribute :location_id do |obj|
    obj.item.location_id
  end
  attribute :location_name do |obj|
    obj.item.location.name
  end  
  attribute :status do |obj|
    if obj.item.class == Task
      obj.item.status
    else
      nil
    end
  end
  attribute :parent do |obj|
    if obj.item.class == Comment
      obj.item.item
    end
  end
  attribute :comments do |obj|
    if obj.item.class != Comment
      obj.item.comments.order(updated_at: :asc).map{|c| c.as_json }
    else
      obj.item.comments.order(updated_at: :asc).map{|c| c.as_json }
    end
  end
end
