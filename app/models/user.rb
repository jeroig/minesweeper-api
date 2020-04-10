class User < ApplicationRecord
  validates :email, presence: true,  uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  has_many :boards, dependent: :destroy

  def payload
    JSON(self.to_json(only: [:id, :email, :password]))
  end

  def token
    JWT.encode(self.payload, Rails.application.credentials.jwt[:secret_key], Rails.application.credentials.jwt[:algorithm])
  end

end
