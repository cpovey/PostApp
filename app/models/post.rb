class Post < ActiveRecord::Base
	belongs_to :user
  has_many :images
  has_many :comments, -> { where parent_id: nil }
end
