class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :num_articles, :admin
  has_many :articles
  def num_articles
    return object.articles.count
  end
end
