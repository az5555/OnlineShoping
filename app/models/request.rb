class Request < ApplicationRecord
  validates :user_id, presence: true
  validates :username, presence: true
end
