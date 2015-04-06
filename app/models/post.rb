class Post < ActiveRecord::Base
  validates :title, :content, :user, presence: true

	belongs_to :user
  has_many :images, :dependent => :delete_all
  has_many :comments, -> { where parent_id: nil }, :dependent => :delete_all
end
