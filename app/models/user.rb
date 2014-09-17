class User < ActiveRecord::Base

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      # user.password = Devise.friendly_token[0,20]
      # user.name = auth.info.name   # assuming the user model has a name
    end
  end

  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end
  #

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

  # def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
  #   data = ActiveSupport::JSON.decode(access_token.get('https://graph.facebook.com/me?'))
  #   if user = User.find_by_email(data["email"])
  #     user
  #   else # Create an user with a stub password.
  #     User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
  #   end
  # end

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
