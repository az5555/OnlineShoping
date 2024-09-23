class Comment < ApplicationRecord
  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :content, presence: { message: "输入为空" }
  validates :content, length: { minimum: 0, maximum: 4000 , message: '评论内容过长'}
  scope :by_product_id, -> (product_id) { where(product_id:product_id) }
  scope :by_user_id, -> (user_id) { where(user_id:user_id) }
  belongs_to :user
  belongs_to :product
end
