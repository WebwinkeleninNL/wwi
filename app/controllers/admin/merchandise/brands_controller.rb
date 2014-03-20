class Admin::Merchandise::BrandsController < Admin::BaseController
  before_filter :verify_owner, only: [:edit, :update, :destroy]

  def index
    @brands = Brand.all
  end

  def show
    @brand = Brand.find(params[:id])
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(allowed_params)
    if @brand.save
      flash[:notice] = "Successfully created brand."
      redirect_to admin_merchandise_brand_url(@brand)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @brand.update_attributes(allowed_params)
      flash[:notice] = "Successfully updated brand."
      redirect_to admin_merchandise_brand_url(@brand)
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @brand.products.empty?
      @brand.destroy
    else
      flash[:alert] = "Sorry this brand is already associated with a product.  You can not delete this brand."
    end

    redirect_to admin_merchandise_brands_url
  end

  private

  def verify_owner
    @brand = Brand.find(params[:id])
    flash[:alert] = 'Sorry, you are not allowed to edit this brand.'

    if @brand.merchant_id != current_user.merchant_id
      redirect_to admin_merchandise_brands_url
    end
  end

  def allowed_params
    params.require(:brand).permit(:name).merge(merchant_id: current_user.merchant_id)
  end

end
