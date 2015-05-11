class User < ActiveRecord::Base
  has_many :posts

  validates :username, uniqueness:true #validacion para que el usuario sea unico"
  validates :email, uniqueness:true
  validates :name, presence:true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  before_save :encryptPassword

  def self.encrypt (pass, salt)  #metodo estatico que junta el salt y el pass y encripta
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
    
  private
    def encryptPassword
      if self.new_record?
        self.salt = generateSalt
        self.password = User.encrypt(self.password, self.salt)
      end
    end

    def generateSalt
        s = SecureRandom.uuid #genera un universal unique  id
        return Digest::SHA2.hexdigest(s) # Encripto el salt
    end

end
