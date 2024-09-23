class Category < ApplicationRecord
  has_many :products , dependent: :destroy
  validates :type_name, presence: {message: "名称不能为空"}
  validates :type_name, length: { minimum: 0, maximum: 12 , message: '名称长度过长'}
  validates :type_name, uniqueness: { message: "该分类已经存在" }
  validates :weight, presence: { message: "权重不能为空" }
  validates :weight, numericality: { only_integer: true, message: "权重必须为整数"},
            if: proc { |category| !category.weight.nil?}
  has_ancestry orphan_strategy: :destroy


  def self.grouped_data
    self.roots.order("weight desc").inject([]) do |result, parent|
      row = []
      row << parent
      row << parent.children.order("weight desc")
      result << row
    end
  end

end
