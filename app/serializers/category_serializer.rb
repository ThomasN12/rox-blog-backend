class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at, :num_articles
  has_many :articles
  def num_articles
    return object.articles.count
  end  
end
