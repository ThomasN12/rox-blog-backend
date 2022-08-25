class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at
  belongs_to :user
  # def user
  #   return object.user.slice('')
  # end
end
