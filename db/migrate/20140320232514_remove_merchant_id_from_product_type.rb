class RemoveMerchantIdFromProductType < ActiveRecord::Migration
  def change
    remove_column :product_types, :merchant_id
  end
end
