class CheckoutController < ApplicationController
  def index
    @user_session = UserSession.new
    @user = User.new
  end
end
