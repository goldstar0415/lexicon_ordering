require 'bcrypt'
class User < ApplicationRecord
  extend Devise::Models
  
  has_many :orders
  belongs_to :user_level
  
  validates_associated :user_level
  validates :user_level_id, presence: true
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
     	
  attr_accessor :reset_token    
  before_create :assign_default_level
  
  delegate :level, to: :user_level
  delegate :min_quantity, to: :user_level
  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::email.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::email.create(string, cost: cost)
  end

  def full_name
    if first_name.present? or last_name.present?
      "#{first_name} #{last_name}"
    else
      email
    end
  end
  
  def full_address
    "#{street_address},<br/>
    #{city}, #{state} - #{zip_code}"
  end
  
  def full_address_csv
    "#{street_address}, #{city}, #{state} - #{zip_code}"
  end
  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # Returns true if a password reset has expired.
  def password_reset_expired?
    #reset_sent_at < 2.hours.ago
  end
  
  private
  
  def assign_default_level
    if !user_level
      self.user_level = UserLevel.where('level = MIN(level)')
    end
  end
  
end
