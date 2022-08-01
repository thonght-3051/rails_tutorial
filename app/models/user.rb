class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.const.users.email.regex.freeze

  before_save :email_downcase

  validates :name, presence: true,
    length: {
      minium: Settings.const.users.name.length.min,
      maximum: Settings.const.users.name.length.max
    }
  validates :email, presence: true,
    length: {
      minium: Settings.const.users.email.length.min,
      maximum: Settings.const.users.email.length.max
    },
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true

  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.const.users.password.length.min}

  def self.digest string
    min_cost = ActiveModel::SecurePassword.min_cost
    cost = min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def email_downcase
    email.downcase!
  end
end
