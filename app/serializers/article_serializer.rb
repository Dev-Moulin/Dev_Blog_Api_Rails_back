class ArticleSerializer
  include JSONAPI::Serializer
  
  attributes :id, :title, :content, :created_at, :updated_at, :user_id, :private
  
  belongs_to :user
end 