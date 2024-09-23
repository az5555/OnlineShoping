class Product < ApplicationRecord
  load 'app/validators/price_validator.rb'
  belongs_to :category
  validates :name, presence: {message: "名称不能为空"}
  validates :name, length: { minimum: 0, maximum: 10 , message: '商品名称过长'}
  validates :name, uniqueness: { message: "该物品已经存在" }
  validates :category_id, presence: {message: "分类不能为空"}
  validates :count, presence: { message: "库存不能为空" }
  validates :count, numericality: { only_integer: true,  message: "库存必须为整数"},
            if: proc { |product| !product.count.nil?}
  validates :price_before, presence: { message: "原价不能为空" },
            if: proc { |product| !product.price_before.nil?}
  validates :price_before, numericality: {  message: "原价必须为数字"}
  validates :price, presence: { message: "价格不能为空" }
  validates :price, numericality: {  message: "价格必须为数字"},
            if: proc { |product| !product.price.nil?}
  validate :price_validation
  validates :description, presence: {  message: "商品描述不能为空"}
  validates :description, length: {minimum: 0, maximum: 4000, message: '描述过长'}
  validates :weight, presence: {  message: "权重不能为空"}
  has_many :product_images, -> { order(weight: "desc")} , dependent: :destroy

  has_many :shopping_carts, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  validates :image, presence: { message: "图片不能为空" }
  has_one :main_product_image, -> { order(weight: 'desc') },
          class_name: :ProductImage

  scope :on_sale, -> { where(status: 1) and where('count > 0')}

  def price_validation
    if !price.nil? && !price_before.nil? && price_before <= price
      errors.add(:price, "原价必须大于标价")
    end
  end
end
