class OmniauthPolicy

  def initialize(auth)
    @auth = auth
  end

  def uid
    @auth.uid
  end

  def provider
    @auth.provider
  end

  def identity_hash
    { uid: uid, provider: provider }
  end

  def user_hash
    hash = {
        #first_name: first_name,
        #last_name:  last_name,
        #username:   username,
        #image_url:  image_url,
    }
    hash[:email] = email if email
    hash
  end

end