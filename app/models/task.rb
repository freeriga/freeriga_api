class Task < ApplicationRecord
  belongs_to :location
  belongs_to :user, optional: true
  belongs_to :user_location, class_name: 'Location'
  translates :summary, fallbacks_for_empty_translations: true
  has_many :comments, as: :item
  validates :username, presence: true
  validates :colour, presence: true
  validates :status, presence: true
  validates :location, presence: true
  validates :user_location, presence: true
  validate :summary_present_in_at_least_one_locale
  globalize_accessors
  accepts_nested_attributes_for :translations, allow_destroy: true, reject_if: lambda {|x| x['summary'].blank? }
  has_one :entry, as: :item, dependent: :destroy
  after_save :update_entry
  has_one_attached :image

  class Translation
    after_save :destroy_if_blank
    # validates :name, presence: true
    validate :locale_is_approved
    validates :locale, presence: true, uniqueness: { scope: :task_id }

    private

    def locale_is_approved
      return true if I18n.available_locales.map(&:to_s).include?(locale)
    end

    def destroy_if_blank
      if summary.blank?
        self.destroy
      end
    end
  end
  
  def update_entry
    Entry.find_or_create_by(item: self).touch
  end

  private

  def summary_present_in_at_least_one_locale
    if translations.map {|x| x.summary }.compact.empty?
      errors.add(:summary, I18n.t('activerecord.errors.models.task.must_have_text_in_one_language'))
    end
  end
end
