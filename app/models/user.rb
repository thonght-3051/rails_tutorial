class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  VALID_EMAIL_REGEX = Settings.const.users.email.regex.freeze

  before_save :email_downcase
  before_create :create_activation_digest

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
    length: {minimum: Settings.const.users.password.length.min},
    allow_nil: true

  class << self
    def digest string
      check_cost = ActiveModel::SecurePassword.min_cost
      cost = check_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.blank?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.const.expired_link_reset_pass.hours.ago
  end

  private

  def email_downcase
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
