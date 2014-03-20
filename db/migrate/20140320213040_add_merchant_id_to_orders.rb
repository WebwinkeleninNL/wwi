class AddMerchantIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :merchant_id, :integer
    add_index :orders, :merchant_id
  end
end
