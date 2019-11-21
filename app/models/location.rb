class Location < ApplicationRecord
  belongs_to :quarter
  validates :name, presence: true, uniqueness: { scope: :quarter_id }
  validates :quarter, presence: true
  has_many :comments, as: :item, dependent: :destroy
  has_many :tasks, dependent: :destroy
  # has_one :entry, as: :item
  # after_save :update_entry

  # def update_entry
  #   Entry.find_or_create_by(item: self).touch
  # end

end
