class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    action_user_login user, params[:session][:remember_me]
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def action_user_login user, remember
    if user&.authenticate(params[:session][:password])
      verify_user user, remember
    else
      flash.now[:danger] = t "login_fail"
      render :new
    end
  end

  def verify_user user, remember
    if user.activated?
      log_in user
      remember == "1" ? remember(user) : forget(user)
      redirect_to user
    else
      flash[:warning] = t "account_not_active"
      redirect_to root_url
    end
  end
end
