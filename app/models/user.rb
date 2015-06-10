
class User < ActiveRecord::Base
  attr_accessor :password_confirmation

  has_many :posts, dependent: :delete_all #si se elimina el modelo se elimina todo lo que este atado.
  has_many :friendships,dependent: :delete_all
  has_many :friends, :through => :friendships
  has_many :comments,dependent: :delete_all
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :messages
  #has_many :receiver_messages, through: :message
  #has_many :inverse_messages, class_name: "Message", foreign_key: "receiver_id"
  #has_many :inverse_send_messages, through: :inverse_messages, source: :user

  mount_uploader :picture, ProfilePictureUploader
  validates :username, uniqueness:true #validacion para que el usuario sea unico"
  validates :email, uniqueness:true
  validates :name, presence:true
  validates :password, length: { minimum: 6}
  validates_confirmation_of :password
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  before_save :encryptPassword, :lowPassword
  before_create :setToken
  #metodo estatico que junta el salt y el pass y encripta
  def self.encrypt (pass, salt)
    encrypt = "#{pass}#{salt}"
    return Digest::SHA2.hexdigest(encrypt)
  end

    def self.authenticate (id, password)
        user ||= User.find_by(username: id)
        user ||= User.find_by(email: id)
        if user
            if user.password == User.encrypt(password,user.salt)
                return user
            end
        end
        return nil
    end

    def self.new_token
      SecureRandom.urlsafe_base64
    end

    def self.setPasswordToken
      begin
       password_token = User.new_token
      end while User.exists?(password_token: password_token)
      return password_token
    end

  private
    def encryptPassword
      if self.new_record? || self.can_edit_password
        self.salt = generateSalt
        self.password = User.encrypt(self.password, self.salt)
      end
    end

    def lowPassword
      self.email.downcase!
    end


    def generateSalt
        s = SecureRandom.uuid #genera un universal unique  id
        return Digest::SHA2.hexdigest(s) # Encripto el salt
    end

    def setToken
      begin
        self.activation_digest = User.new_token
      end while User.exists?(activation_digest: self.activation_digest)

    end
end
