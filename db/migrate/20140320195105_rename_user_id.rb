class RenameUserId < ActiveRecord::Migration
  def change
    [:products, :prototypes, :properties, :product_types].each do |table|
      rename_column table, :user_id, :merchant_id
      rename_index  table, "index_#{table}_on_user_id", "index_#{table}_on_merchant_id"
    end
  end
end
