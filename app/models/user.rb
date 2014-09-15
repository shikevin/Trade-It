class User < ActiveRecord::Base
  before_save { self.email = email.downcase } #callback to force downcase email before saving
  before_create :create_remember_token

  has_many :microposts, dependent: :destroy
  has_many :sellingbooks, dependent: :destroy
  has_many :wantedbooks, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 } #same as validates(:name, presence : true)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  has_secure_password

  devise :omniauthable, :omniauth_providers => [:facebook]
  # attr_accessible :password, :password_confirmation

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def sell_feed
    Sellingbook.where("user_id = ?", id)
  end

  def want_feed
    Wantedbook.where("user_id = ?", id)
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
