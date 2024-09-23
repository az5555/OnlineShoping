class ShoppingCart < ApplicationRecord
  validates :product_id, presence: true
  validates :amount, presence: true
  validates :user_id, presence: true
  belongs_to :product

  scope :by_user_id, -> (user_id) { where(user_id: user_id) }

  def self.create_or_update options = {}
    cond = {
      user_id: options[:user_uid],
      product_id: options[:product_id]
    }

    record = where(cond).first
    if !record.nil?
      record.update(amount:  (record.amount + options[:amount]))
    else
      record = create!(options)
    end

    record
  end
end
