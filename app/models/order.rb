class Order < ApplicationRecord

  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :user_name, presence: true
  validates :product_name, presence: true

  validates :total_money, presence: true
  validates :amount, presence: true
  validates :status, presence: true

  scope :by_user_id, -> (user_id) { where(user_id: user_id) }
  scope :waiting, -> { where(status: 0)}
  scope :by_deliver_id, -> (deliver_id) { where(deliver_id: deliver_id) and where(status: 1)}
  belongs_to :user
  belongs_to :product

end
