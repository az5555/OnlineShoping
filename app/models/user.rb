class User < ApplicationRecord
  attr_accessor :password_confirmation
  validates :email, presence: {message: "邮箱不能为空"}
  validates :email, length: { minimum: 0, maximum: 100 , message: '邮箱过长'}
  validates :address, presence: {message: "地址不能为空"}
  validates :address, length: { minimum: 0, maximum: 100 , message: '地址过长'}
  validates :email, uniqueness: { message: "邮箱已经存在" }
  validates :username, presence: {message: "用户名不能为空"}
  validates :username, length: { minimum: 2, maximum: 6 , message: '用户名需要在2到6个字之间'}
  validates :password, presence: { message: "密码不能为空" }, if: :password_is_changed
  validates :password_confirmation, presence: { message: "重复密码不能为空" }, if: :password_is_changed
  validates_confirmation_of :password, message: "两次输入密码不一致", if: :password_is_changed
  validates_length_of :password, maximum: 20, minimum: 6, message: "密码长度请介于6和20之间", if: :password_is_changed
  validates_format_of :email, with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/, message: "邮箱不合法",
                      if: proc { |user| !user.email.nil?}
  private
  def password_is_changed
    self.new_record? || !password.nil? || !password_confirmation.nil?
  end

  has_one_attached :image

  scope :deliver, -> { where(role: "delivery")}

end
