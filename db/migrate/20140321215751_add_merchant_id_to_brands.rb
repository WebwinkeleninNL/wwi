class AddMerchantIdToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :merchant_id, :integer
    add_index  :brands, :merchant_id
  end
end
