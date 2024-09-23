# README

#### rails以及ruby版本

使用最新版本

```ruby
ruby "3.2.2"
gem "rails", "~> 7.1.2"
```

#### gem依赖

bootstrap 和 font-awesome-sass用于前端，ancestry用以实现一个树状的继承关系，will_paginate是实现换页的插件。

```ruby
gem "sassc-rails"
gem "bootstrap"
gem "font-awesome-sass", "~> 6.4.2" 
gem "ancestry"
gem "will_paginate"
```

#### 实体表以其约束实现

- User

  ```ruby
  t.string "type_name"
  t.integer "weight", default: 0
  t.integer "counter", default: 0
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string "ancestry"
  ```

  ```ruby
  attr_accessor :password_confirmation
  validates :email, presence: {message: "邮箱不能为空"}
  validates :email, uniqueness: { message: "邮箱已经存在" }
  validates :password, presence: { message: "密码不能为空" }
  validates :password_confirmation, presence: { message: "重复密码不能为空" }
  validates_confirmation_of :password, message: "两次输入密码不一致"
  validates_length_of :password, maximum: 20, minimum: 6, message: "密码长度请介于6和20之间"
  validates_format_of :email, with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/, message: "邮箱不合法"
  ```

- ShoppingCart

  ```ruby
  t.integer "user_id"
  t.integer "product_id"
  t.integer "amount"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  ```

  ```ruby
   validates :product_id, presence: true
   validates :amount, presence: true
   belongs_to :product
  ```

- Product

  ```ruby
  t.string "name"
  t.integer "category_id"
  t.integer "status", default: 1
  t.integer "count"
  t.decimal "price", precision: 8, scale: 2
  t.decimal "price_before", precision: 8, scale: 2
  t.text "description"
  t.datetime "add_timestamps"
  t.datetime "created_at", null: false
  ```

  ```ruby
  belongs_to :category
    validates :name, presence: {message: "名称不能为空"}
    validates :name, uniqueness: { message: "该物品已经存在" }
    validates :category_id, presence: {message: "分类不能为空"}
    validates :count, uniqueness: { message: "库存不能为空" }
    validates :count, numericality: { only_integer: true,  message: "库存必须为整数"},
              if: proc { |product| !product.count.nil?}
    validates :price, uniqueness: { message: "价格不能为空" }
    validates :price, numericality: {  message: "价格必须为数字"},
              if: proc { |product| !product.price.nil?}
    validates :price_before, uniqueness: { message: "原价不能为空" },
              if: proc { |product| !product.price_before.nil?}
    validates :price_before, numericality: {  message: "原价必须为数字"}
    validates :description, uniqueness: {  message: "商品描述不能为空"}
    validates :status, uniqueness: {  message: "商品状态不能为空"}
  
    has_many :product_images, -> { order(weight: "desc")} , dependent: :destroy
  
    has_many :shopping_carts, dependent: :destroy
    has_many :collections, dependent: :destroy
  
    has_one :main_product_image, -> { order(weight: 'desc') },
            class_name: :ProductImage
  
  ```

- Order

  ```ruby
   t.integer "user_id"
   t.string "user_name"
   t.integer "product_id"
   t.string "product_name"
   t.integer "amount"
   t.datetime "pay_time"
   t.decimal "total_money", precision: 8, scale: 2
   t.datetime "created_at", null: false
   t.datetime "updated_at", null: false
   t.integer "status", default: 0
  ```

  ```ruby
  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :user_name, presence: true
  validates :product_name, presence: true
  validates :total_money, presence: true
  validates :amount, presence: true
  belongs_to :user
  belongs_to :product
  ```

- Collection

  ```ruby
   t.integer "user_id"
   t.integer "product_id"
   t.datetime "created_at", null: false
   t.datetime "updated_at", null: false
  ```

  ```ruby
    validates :product_id, presence: true
    belongs_to :product
  ```

- Category(分类)

  ```ruby
  t.string "type_name"
  t.integer "weight", default: 0
  t.integer "counter", default: 0
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string "ancestry"
  ```

  ```ruby
  has_many :products , dependent: :destroy
  validates :type_name, presence: {message: "名称不能为空"}
  validates :type_name, uniqueness: { message: "该分类已经存在" }
  validates :weight, presence: { message: "权重不能为空" }
  validates :weight, numericality: { only_integer: true, message: "权重必须为整数"},
            if: proc { |category| !category.weight.nil?}
  has_ancestry orphan_strategy: :destroy
  ```

设置table_id作为字段，rails就能自动将外键连接到对应的表，十分的方便；使用时可以直接将外键对应的表当作类的元素取出。

对于外键依赖，我们都采用连带删除的策略，把外键指向该元素的元素全部连带删除。

#### Controller的实现

Controller是后端部分，与数据库直接交互。在每一个Controller中，rails默认会为我们创建六种方法，每种方法对对应一种行为，我们也能在路由中声明，创建单独的方法。在Controller中，我们直接与数据库进行交互，rails为我们提供了相当便利的查询方式，既能通过rails自带的主键和字段查询，也能间接调用SQL语言。这里介绍rails自带的六种方法。

- index：该方法是展示对应模型内所有的元素。
- show：该方法对应一个元素的详细展示，使用时需要我们传入对应的id。
- new：对应用于创建元素的页面，在这个方法中我们要把对应view中用到的对象声明出来。
- create：该方法用于创建一个表内元素。
- edit：该方法用于修改元素的页面，在这个方法中我们要把对应view中用到的对象声明出来。
- destory：该方法用于销毁一个元素。

#### View的实现

View对应前端，是用户和页面交互实现的地方。这是本次project中任务最大的部分，有着大量繁杂的工作；借用bootstrap和font-awesome我得以实现一个简易的页面。其中，每一个new，edit，index和show方法都会对应一个View视图，我们能通过<% %>来调用我们ruby的代码，实现我们想要的功能。当然要实现一个复杂的页面，这些是远远不够的。实现View我认为要熟悉html语言以及View中的几个方法，例如link_to和botton_to，两个方法都是跳转到一个路由，但是两个方法对应的method不完全相同，因此两者用法也有区别。再就是form_for和form_tag虽然两者用途相似，但还是有细微的不同。

同时，我们要熟练掌握controller方法和路由的对应关系，在本次project中，众多的bug就是因为没掌握对应方法导致。

#### 用户验证系统的实现

在本次project中，我并没有使用Device插件快速简易实现用户验证系统，因为其中代码过于复杂繁多，遇到问题完全找不出是哪里出现了问题。因此，我自己实现了一个用户验证系统。首先是两个全局定义的方法。

```ruby
def current_user
    @current_user ||= User.find(session[:user]) if session[:user]
end # 用于获取当前的用户

def user_signed_in?
    !current_user.nil?
end # 用于判断用户是否登入
```

利用session[:user]在存储登入后的user_id，通过session[:user]来获取当前的用户。同时，我们要声明并将这些

```ruby
helper_method :current_user, :user_signed_in?
```

代码写在ApplicationController类中。这样上述方法都可以所有的controller和view中都可以调用。登入时，我们从数据库中通过邮箱获取当前登入用户的用户id，用session进行存储；当退出时，我们直接将session设置为空就能实现了。

#### 管理员后台的实现

在本次project中，我将管理员资源都放在了一个独立的命名空间，这样一来，普通用户就无法获取管理员资源。对不同用户仅仅开放商品和分类的index和show路由，如此保证了对应数据的安全。由于上传到服务器无法使用命令行来为任命管理员，因此，我在用户中心的修改页面添加了管理员密钥来任命管理员，密钥为“21373399”。

管理员拥有很多普通用户无法接触的资源，负责对于订单，商品和分类的日常维护，增删和修改。

为了实现管理员的资源独立，我为管理员创建了admin命名空间，其中的controller和view都是独立与普通用户的，但是两者共用一个模型。

```ruby
 namespace :admin do
    resources :sessions
    resources :categories
    resources :products 
    resources :orders
  end
```

#### 通知和警告的实现

通知和警告的实现利用了flash存储，flash不同于session其在每一个页面中都会被刷新。这样就方便我们后端利用falsh来传递信息我们利用flash[:notice]来传递提示，利用flash[:danger]来传递警告，当渲染一个新页面时，我们都会检查flash[:notice]和flash[:danger]是否为空，如果不为空就渲染对应的通知信息。

#### 安全验证

我们在ApplicationController类中定义，这样就能让没有权限的用户或者没有登入的用户无法进入一些页面来修改

```ruby
protected

  def auth_user
    unless user_signed_in?
      flash[:notice] = "请登入"
      redirect_to new_session_path
      return
    end
  end

  def auth_admin
    unless user_signed_in?
      flash[:notice] = "请登入"
      redirect_to new_session_path
      return
    end

    unless user_admin_in?
      flash[:notice] = "非管理员请勿进入后台"
      redirect_to root_path
      return
    end
  end
```

在一些需要登入或者需要管理员权限的地方加上

```ruby
before_action :auth_user
before_action :auth_admin
```

来预防有人进入管理员后台修改对应资源，或者未登入修改别人购物车或者收藏夹。

#### 搜查功能的实现

搜索功能依赖于product资源因此，我们在路由中定义，由于搜索到很多商品，用:collection关键字

```ruby
resources :products, only: [:show] do
  get :search, on: :collection
end
```

在controller中我们可以利用数据库的模糊搜索，直接获取所要的数据

```ruby
@products = Product.where("name like ?", "%" + params[:w] + "%")
```

#### 状态说明

- product

  | status | 对应状态 |
  | ------ | -------- |
  | 0      | 停止销售 |
  | 1      | 正在销售 |

- order

  | status | 对应状态 |
  | ------ | -------- |
  | 0      | 待发货   |
  | 1      | 已发货   |

  #### 图片上传功能
  
  可以利用**Active Storage**来实现，但是电脑安装对应gem时出现循环依赖，暂时无法实现该功能。
