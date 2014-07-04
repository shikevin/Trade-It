class User < ActiveRecord::Base
  before_save { self.email = email.downcase } #callback to force downcase email before saving

  validates :name, presence: true, length: { maximum: 50 } #same as validates(:name, presence : true)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
end
