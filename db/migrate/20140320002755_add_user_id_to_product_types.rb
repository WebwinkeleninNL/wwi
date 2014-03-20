class AddUserIdToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :user_id, :integer
    add_index :product_types, :user_id
  end
end
