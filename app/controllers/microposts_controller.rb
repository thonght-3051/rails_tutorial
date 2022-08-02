class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :find_micropost, only: %i(destroy)
  before_action :action_create_micropost, only: %i(create)

  def create
    if @micropost.save
      flash[:success] = t "micropost.created"
    else
      flash[:danger] = t "micropost.create_fail"
      @pagy, @feed_items = pagy current_user.feed, items: Settings.const.paginate
    end
    redirect_to root_url
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.deleted"
    else
      flash[:danger] = t "micropost.delete_fail"
    end

    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::REQUEST_VARIABLE
  end

  def find_micropost
    @micropost = find_object current_user.microposts, params[:id]
  end

  def action_create_micropost
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach(params[:micropost][:image])
  end
end
