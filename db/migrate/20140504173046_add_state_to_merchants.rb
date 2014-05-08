class AddStateToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :state, :string
  end
end
