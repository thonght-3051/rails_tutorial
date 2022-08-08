class FollowsController < ApplicationController
	before_action :logged_in_user, :find_user, only: %i(following followers)
  def following
    @title = t "following"
    @pagy, @users = pagy @user.following, items: Settings.const.paginate
    render "users/show_follow"
  end

  def followers
    @title = t "followers"
    @pagy, @users = pagy @user.following, items: Settings.const.paginate
    render "users/show_follow"
  end

  private
  def find_user
    @user = find_object User, params[:id]
  end
end
