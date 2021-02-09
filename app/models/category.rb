class Category < ApplicationRecord
  acts_as_paranoid
  acts_as_list
  has_many :products

  default_scope { order(position: :asc) }
  validates :name, presence: true
end
