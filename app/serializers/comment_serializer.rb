class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :updated_at
  has_one :user
  has_many :comments

  def user
    {id: object.user.id}
  end
end
