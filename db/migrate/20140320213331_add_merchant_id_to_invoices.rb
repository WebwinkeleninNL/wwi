class AddMerchantIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :merchant_id, :integer
    add_index  :invoices, :merchant_id
  end
end
