class AddMerchantIdToShippingCategories < ActiveRecord::Migration
  def change
    add_column :shipping_categories, :merchant_id, :integer
    add_index  :shipping_categories, :merchant_id
  end
end
