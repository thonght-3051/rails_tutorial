class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    locale_avaiable = I18n.available_locales.include?(locale)
    I18n.locale = locale_avaiable ? locale : I18n.default_locale
  end

  private

  before_action :set_locale

  def default_url_options
    {locale: I18n.locale}
  end

  def find_object model, id
    model.find(id)
  rescue StandardError
    template_not_found
  end

  def template_not_found
    render file: Rails.root.to_s << ("/public/404.html")
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "need_login"
    redirect_to login_url
  end
end
