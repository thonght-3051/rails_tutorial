class UsersController < ApplicationController
  def show
    @user = find_object(User, params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "welcome_app"
      redirect_to @user
    else
      flash[:danger] = t "sign_up_failed"
      render :new
    end
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end
end
