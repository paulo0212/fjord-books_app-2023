# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  around_action :switch_locale, default_url_options

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
