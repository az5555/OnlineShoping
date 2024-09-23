class Collection < ApplicationRecord
  validates :product_id, presence: true
  validates :user_id, presence: true
  scope :by_user_id, -> (user_id) { where(user_id: user_id) }
  belongs_to :product
end
