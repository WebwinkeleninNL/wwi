class AddFieldsToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :email, :string
    add_column :merchants, :phone, :string
  end
end
