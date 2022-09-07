class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at, :user, :categories
  # has_many :categories
  # belongs_to :user
  def user
    return object.user.slice(:admin, :email, :id, :username, :created_at, :updated_at)
  end

  def categories
    return object.categories
  end
end
