class User < ActiveRecord::Base
  validates :name, :city, presence: true

	has_many :posts
end
