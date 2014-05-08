class Admin::MerchantsController < Admin::BaseController
  layout "admin"
  before_filter :verify_super_admin
  respond_to :html, :json

  def index
    @merchants = Merchant.all.paginate page: params[:page]

    respond_to do |format|
      format.html
      format.json{ render json: @merchants }
    end
  end

  def show
    @merchant = Merchant.find(params[:id])
    #@merchant.orders

    respond_to do |format|
      format.json{ render json: @merchant }
    end
  end

  def new
    @merchant = Merchant.new
    authorize! :create_merchants, current_user
  end

  def create
    @merchant = Merchant.new(merchant_params)
    authorize! :create_merchants, current_user
    respond_to do |format|
      if @merchant.save
        flash[:notice] = "Merchant has been created."
        format.html{ redirect_to admin_merchants_url }
        format.json{ render json: {status: :ok }  }
      else
        format.html{ render :action => :new }
        format.json{ render json: {status: :error} }
      end
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
    authorize! :create_merchants, current_user
  end

  def update
    @merchant = Merchant.find(params[:id])
    authorize! :create_merchants, current_user

    respond_to do |format|
      if @merchant.update_attributes(merchant_params)
        msg = "#{@merchant.name} has been updated."
        format.html do
          flash[:notice] = msg
          redirect_to admin_merchants_url
        end
        format.json{ render json: {status: :ok, message: msg }  }
      else
        format.html{ render :action => :edit }
        format.json{ render json: {status: :error} }
      end
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name, :description, :url, :email, :phone, :location, :state)
  end
end
