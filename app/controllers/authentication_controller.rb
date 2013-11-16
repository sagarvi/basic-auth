class AuthenticationController < ApplicationController
  def sign_in
    @user = User.new
  end

  def login
    u_or_e = params[:user][:username]
    pass = params[:user][:password]

    if u_or_e.rindex('@')
       user = User.authenticate_by_email(u_or_e, pass)
    else
      user = User.authenticate_by_username(u_or_e, pass)
    end

    if verify_recaptcha
      if user
        session[:user_id] = user.id
        flash[:notice] = "Welcome"
        redirect_to :root
      else
        flash[:error] = "Invalid username/email or password"
        redirect_to :sign_in
      end
    else
      flash.delete(:recaptcha_error) # get rid of the recaptcha error being flashed by the gem.
      flash[:error] = 'reCAPTCHA is incorrect. Please try again.'
      redirect_to  :sign_in
    end

  end

  def signed_out
    session[:user_id] = nil
    flash[:notice] = "Successfully Logged out!!! Visit again!!!"
  end

  def new_user
    @user = User.new
  end

  def register
    @user = User.new(params[:user])

    if verify_recaptcha
      if @user.valid?
        @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Welcome #{@user.username}"
        redirect_to :root
      else
        render :action => "new_user"
      end
    else
      flash.delete(:recaptcha_error) # get rid of the recaptcha error being flashed by the gem.
      flash.now[:error] = 'reCAPTCHA is incorrect. Please try again.'
      render :action => "new_user"
    end
  end

end
