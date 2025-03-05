class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  # Relations
  has_many :articles, dependent: :destroy

  # Ajout de validations supplémentaires si nécessaire
  validates :email, presence: true, uniqueness: true

  def generate_jwt
    JWT.encode(
      { 
        sub: id,
        scp: 'user',
        aud: nil,
        iat: Time.current.to_i,
        exp: 24.hours.from_now.to_i,
        jti: SecureRandom.uuid
      },
      Rails.application.credentials.devise_jwt_secret_key
    )
  end
end
