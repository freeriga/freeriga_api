class Entry < ApplicationRecord
  belongs_to :item, polymorphic: true
  after_save :broadcast_to_channel

  def broadcast_to_channel
    ActionCable.server.broadcast('site_channel', EntrySerializer.new(self, includes: [:item]).serialized_json)
  end

  def parent
    if item.class == Comment
      comment.parent
    else
      item
    end
  end
end
