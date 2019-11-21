class Quarter < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  has_many :locations, dependent: :destroy
  has_many :tasks, through: :locations
  has_many :comments, as: :item, dependent: :destroy
  # has_one :entry, as: :item
  # after_save :update_entry

  # def update_entry
  #   Entry.find_or_create_by(item: self).touch
  # end
end
