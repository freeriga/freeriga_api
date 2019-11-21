class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :username, :colour, :location, :body_lv, :body_en, :body_ru, :item_type, :item_id, :created_at, :updated_at
  attribute :entry_id do |obj|
    obj.item.entry_id
  end
  belongs_to :item, polymorphic: true
end
