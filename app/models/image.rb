class Image < ActiveRecord::Base
  validates :url, :post, presence: true

  belongs_to :post
end