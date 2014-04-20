class CheckoutController < ApplicationController
  def index
    if session_cart.shopping_cart_items.empty?
      flash[:notice] = I18n.t('do_not_have_anything_in_your_cart')
      redirect_to products_url and return
    end

    if current_user.nil? && (params[:step].nil? || (!params[:step].nil? && params[:step].to_i == 1))
      @user_session = UserSession.new
      @user = User.new
      @step = 1
    elsif !params[:step].nil? && [2,3,4].include?(params[:step].to_i)
      @step = params[:step].to_i

      case @step
      when 2
        @shopping_address = Address.new
        if !Settings.require_state_in_address && countries.size == 1
          @shopping_address.country = countries.first
        end
        form_info
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  before_filter :to_step_2, :to_step_1

  private

  def to_step_1
    redirect_to(checkout_path(step: 1)) if current_user.nil? || params[:step].nil?
  end

  def to_step_2
    redirect_to(checkout_path(step: 2)) if !current_user.nil? && !params[:step].nil? && params[:step].to_i == 1
  end

  def countries
    @countries ||= Country.active
  end

  def form_info
    @shopping_addresses = current_user.shipping_addresses
    @states     = State.form_selector
  end

  def allowed_params
    params.require(:address).permit(:first_name, :last_name, :address1, :address2, :city, :state_id, :state_name, :zip_code, :default, :billing_default, :country_id)
  end

end
