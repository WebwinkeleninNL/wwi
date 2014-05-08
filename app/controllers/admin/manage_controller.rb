class Admin::ManageController < Admin::BaseController
  layout 'manage'

  before_filter :verify_super_admin

  def dashboard
  end

  def merchants
    render layout: false
  end

  def merchant
    render layout: false
  end
end