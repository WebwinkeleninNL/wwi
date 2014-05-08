class Merchant < ActiveRecord::Base
  has_many :users
  has_many :products

  validates :url, :name, :description, presence: true

  def orders
    Order.includes(:order_items => {:variant => :product}).where("products.merchant_id = ?", id).references(:products)
  end

    # def as_json
    #   {name: 1}
    # end
end
