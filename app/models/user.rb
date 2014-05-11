class User < ActiveRecord::Base
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :identities, inverse_of: :user
  accepts_nested_attributes_for :identities

  after_create :create_identity

  def create_identity
    identities.each &:save
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = identity.user

    if user.nil?
      # Get the existing user by email if the OAuth provider gives us a verified email
      # If the email has not been verified yet we will force the user to validate it
      email = auth.info.email if auth.info.verified_email
      user = User.find_by(email: email) if email

      # Create the user if it is a new registration
      if user.nil?
        user = User.new(
            #name: auth.extra.raw_info.name,
            #username: auth.info.nickname || auth.uid,
            email: email ? email : 'mymail@mail.com',
            password: Devise.friendly_token[0,20]
        )
        #user.skip_confirmation!
        user.save!
      end

      # Associate the identity with the user if not already
      if identity.user != user
        identity.user = user
        identity.save!
      end
    end
    user
  end

end
