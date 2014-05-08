class RemoveMerchantIdFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :merchant_id
  end
end
