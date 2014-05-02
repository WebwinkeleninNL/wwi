class CheckoutController < Shopping::BaseController
  helper_method :countries, :phone_types

  def index
    if session_cart.shopping_cart_items.empty?
      flash[:notice] = I18n.t('do_not_have_anything_in_your_cart')
      redirect_to products_url and return
    end

    if current_user.nil?
      @user_session = UserSession.new
      @user = User.new
      @step = 1
    elsif [0,2,3,4].include?(params[:step].to_i)
      @step = params[:step].to_i
      @order = find_or_create_order

      case @step
      when 2
        @form_address = @shopping_address = Address.new
        @form_address.phones.build
        if !Settings.require_state_in_address && countries.size == 1
          @shopping_address.country = countries.first
        end
        form_info
      when 3
        session_order.find_sub_total
        ##  TODO  refactor this method... it seems a bit lengthy
        @shipping_method_ids = session_order.ship_address.shipping_method_ids

        @order_items = OrderItem.includes({:variant => {:product => :shipping_category}}).order_items_in_cart(session_order.id)
        #session_order.order_
        @order_items.each do |item|
          item.variant.product.available_shipping_rates = ShippingRate.with_these_shipping_methods(item.variant.product.shipping_category.shipping_rate_ids, @shipping_method_ids)
        end
      when 4

      end
    elsif params[:step].nil? || params[:step] == '1'
      skip_auth_step
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def result
    response = OmniKassa::Response.new(params)
    #@order = response.order_id

    return if response.pending?

    if response.successful?
      #@order.paid = true
      #@order.save
      flash[:notice] = "Payment succeeded"
      redirect_to root_url
    else
      flash[:notice] = "Payment failed"
      redirect_to root_url
    end
  end

  private

  def skip_auth_step
    redirect_to checkout_path(step: 2)
  end

  def countries
    @countries ||= Country.active
  end

  def phone_types
    @phone_types ||= PhoneType.all.map{|p| [p.name, p.id]}
  end

  def form_info
    @shopping_addresses = current_user.shipping_addresses
    @states     = State.form_selector
  end

  def allowed_params
    params.require(:address).permit(:first_name, :last_name, :address1, :address2, :city, :state_id, :state_name, :zip_code, :default, :billing_default, :country_id)
  end

end
