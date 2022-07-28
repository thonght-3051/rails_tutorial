class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    action_user_login user
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def action_user_login user
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t "login_fail"
      render :new
    end
  end
end
