class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.all, items: Settings.const.paginate
  end

  def show
    @pagy, @microposts = pagy @user.microposts, items: Settings.const.paginate
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email_active"
      redirect_to root_url
    else
      flash[:danger] = t "sign_up_failed"
      render :new
    end
  end

  def edit; end

  def update
    current_password = params[:user][:old_password]
    if @user.authenticate(current_password) && @user.update(user_params)
      flash[:success] = t "update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "update_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "success_deleted"
    else
      flash[:danger] = t "fail_delete"
    end

    redirect_to users_url
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "need_login"
    redirect_to login_url
  end

  def correct_user
    return template_not_found if @user.nil?

    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = find_object User, params[:id]
  end
end
