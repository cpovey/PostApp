class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :author_name, :author_city, :images, :updated_at

  def author_name
    object.user.name
  end

  def author_city
    object.user.city
  end

  def images
    object.images.to_a.map{ |i| {url: i.url} }
  end
end
