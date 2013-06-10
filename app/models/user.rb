class User < ActiveRecord::Base
  attr_accessible :email, :nick_name, :password, :password_confirmation
  has_secure_password
  validates :password, presence: true
   before_save :create_remember_token
  has_many :lists

  def new

  end


  private
   def create_remember_token
     self.remember_token = SecureRandom.urlsafe_base64 # If u just say remember_token= ...   then local variable
                                                       # remember_token is created...If u want to access table column
                                                       #remember_token...u need to use self.remember_token...
   end

end
