class RemoveMerchantUsers < ActiveRecord::Migration
  def change
    drop_table :merchant_users
  end
end
