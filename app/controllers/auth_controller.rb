class AuthController < ApplicationController
  include AuthHelper

  def gettoken
    render text: params[:code]
  end
end
