class HomeController < ApplicationController
  include AuthHelper

  def index
    # Display the login link.
    @login_url = get_login_url
  end
end
