class AddMerchantIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :merchant_id, :integer
    add_index :users, :merchant_id
  end
end
