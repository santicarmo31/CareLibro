class Post < ActiveRecord::Base
    has_many :comments, dependent: :delete_all #Si se borra el modelo todos los comentarios se borran
  belongs_to :user
end
