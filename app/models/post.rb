class Post < ActiveRecord::Base
    self.per_page = 5
    has_many :comments, dependent: :delete_all #Si se borra el modelo todos los comentarios se borran
    belongs_to :user
end
