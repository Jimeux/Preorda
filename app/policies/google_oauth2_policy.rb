class GoogleOauth2Policy < OmniauthPolicy

  def first_name
    @auth.info.first_name
  end

  def last_name
    @auth.info.last_name
  end

  def email
    @auth.info.email
  end

  def username
    first_name + last_name
  end

  def image_url ; end

  def oauth_token
    @auth.credentials.token
  end

  def oauth_expires
    Time.at(@auth.credentials.expires_at)
  end

  def oauth_secret ; nil end

  def create_callback(account)
    # Place any methods you want to trigger on Facebook OAuth creation here.
  end

  def refresh_callback(account)
    # Place any methods you want to trigger on subsequent Facebook OAuth logins here.
  end

end