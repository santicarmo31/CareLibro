class Auth < ActiveRecord::Base
  belongs_to :user

  before_save :generate_token

 def self.authenticate(email, password)
   user = User.authenticate(email, password)

   if user
     token = Auth.new

     if Auth.exists? user: user
       token = Auth.find_by user: user
     end

     token.user_id = user.id

     if token.save
       return token
     end
   end
 end

 def valid_token?
   self.expires >= DateTime.now
 end

 def rebuild_token
   generate_token 15
 end

 private
 def generate_token(timelife = 360)
   begin
     self.token = SecureRandom.hex 64
   end while Auth.exists? token: self.token

   self.expires = DateTime.now + timelife
 end
end
