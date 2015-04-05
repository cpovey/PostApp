class Comment < ActiveRecord::Base
  validates :content, :user, :post, presence: true

  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: "Comment"
  has_many :comments, foreign_key: :parent_id
end