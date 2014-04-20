class Customer::ProfilesController < ApplicationController
  before_filter :require_user

  def show
    @profile = current_user
  end
end
