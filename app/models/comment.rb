class Comment < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :location
  belongs_to :user, optional: true
  translates :body
  validates :item, presence: true
  validates :username, presence: true
  validates :colour, presence: true
  validates :location, presence: true
  validate :body_present_in_at_least_one_locale
  globalize_accessors
  accepts_nested_attributes_for :translations, allow_destroy: true, reject_if: lambda {|x| x['body'].blank? }
  has_one :entry, as: :item, dependent: :destroy
  before_save :prevent_nested_comments
  after_save :update_entry
  has_many :comments, as: :item

  class Translation
    after_save :destroy_if_blank
    # validates :name, presence: true
    validate :locale_is_approved
    validates :locale, presence: true, uniqueness: { scope: :comment_id }

    private

    def locale_is_approved
      return true if I18n.available_locales.map(&:to_s).include?(locale)
    end

    def destroy_if_blank
      if body.blank?
        self.destroy
      end
    end
  end

  def prevent_nested_comments
    if item.class == Comment
      if item.entry.nil?
        self.item = self.item.item
      end
    end
  end

  def as_json(options = {})
    {
      :id => self.id,
      :translations_count => self.body_translations.size,
      :translations_hash => self.body_translations,
      :item_type =>  self.item_type,
      :item_id => self.item_id,
      :username => self.username,
      :location_id => self.location_id,
      :colour => self.colour,
      :created_at => self.created_at,
      :updated_at => self.updated_at,
      :body => self.body
    }    
  end

  def update_entry
    if item.class == Task
      item.entry.touch
    else
      if item.class == Comment
        item.entry.touch
      else
        Entry.find_or_create_by(item: self).touch
      end
    end
  end

  private

  def body_present_in_at_least_one_locale
    if translations.map {|x| x.body }.compact.empty?
      errors.add(:body, I18n.t('activerecord.errors.models.comment.must_have_text_in_one_language'))
    end
  end
end
