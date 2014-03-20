class AddUserIdPrototype < ActiveRecord::Migration
  def change
    add_column :prototypes, :user_id, :integer
    add_index :prototypes, :user_id        
  end
end
