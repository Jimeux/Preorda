class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action do
    redirect_to root_path unless current_user && current_user.admin?
  end #TODO: Remove when adding user features back in

  # Make it clear that a new account will be created

  def twitter  ; callback end
  def facebook ; callback end

  def create
    @user = User.new(user_params)
    @user.password = Devise.friendly_token
    if @user.save
      login_user @user
    else
      @existing_user = User.find_by(email: @user.email) # TODO: Remove duplicated code
      render 'omniauth/new'
    end
  end

  private

  def callback
    current_user ? add_provider : create_user
  end

  def add_provider
    identity = current_user.identities.create(auth_hash.identity_hash)
    if !identity.persisted? && is_navigational_format?
      set_flash_message(:notice, :failure, kind: auth_hash.provider, reason: 'somebody else has registered this account')
    end
    redirect_to edit_user_registration_path
  end

  def create_user
    identity = Identity.find_by(provider: auth_hash.provider, uid: auth_hash.uid)

    if identity.try(:user)
      login_user(identity.user)
    else
      @user = User.new(auth_hash.user_hash)
      @user.identities.build(auth_hash.identity_hash)
      @existing_user = User.find_by(email: @user.email)
      render 'omniauth/new'
    end
  end

  def auth_hash
    @auth_hash ||= begin
      auth = env['omniauth.auth']
      "#{auth.provider}_policy".classify.constantize.new(auth)
    end
  end

  def login_user(user)
    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: 'provider') if is_navigational_format?
  end

  def user_params
    params.require(:user).permit(:email, identities_attributes: [:uid, :provider])
  end

end