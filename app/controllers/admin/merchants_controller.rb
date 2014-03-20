class Admin::MerchantsController < Admin::BaseController
  layout "admin"

  def index
    @merchants = Merchant.all.paginate page: params[:page]
  end

  def new
    @merchant = Merchant.new
    authorize! :create_merchants, current_user
  end

  def create
    @merchant = Merchant.new(merchant_params)
    authorize! :create_merchants, current_user
    if @merchant.save
      flash[:notice] = "Merchant has been created."
      redirect_to admin_merchants_url
    else
      form_info
      render :action => :new
    end
  end

  def edit
    @merchant = Merchant.includes(:roles).find(params[:id])
    authorize! :create_merchants, current_user
    form_info
  end

  def update
    @merchant = Merchant.find(params[:id])
    authorize! :create_merchants, current_user

    if @merchant.update_attributes(merchant_params)
      flash[:notice] = "#{@merchant.name} has been updated."
      redirect_to admin_users_url
    else
      form_info
      render :action => :edit
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name, :description, :url)
  end
end
