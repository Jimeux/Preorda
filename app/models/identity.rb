class Identity < ActiveRecord::Base
  belongs_to :user, inverse_of: :identities

  validates_presence_of :user
  validates_presence_of   :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def self.find_for_oauth(auth)
    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
    identity
  end
end