# user model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :auth_token
  before_create :generate_authentication_token!

  def info
    "#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end

  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      break unless User.exists?(auth_token: auth_token)
    end
  end
end
