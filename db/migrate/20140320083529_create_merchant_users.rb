class CreateMerchantUsers < ActiveRecord::Migration
  def change
    create_table :merchant_users do |t|
      t.integer :user_id
      t.integer :merchant_id
    end
  end
end
