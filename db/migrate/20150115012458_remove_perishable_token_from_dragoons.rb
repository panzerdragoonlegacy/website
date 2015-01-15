class RemovePerishableTokenFromDragoons < ActiveRecord::Migration
  def up
    remove_column :dragoons, :perishable_token
    remove_column :dragoons, :perishable_token_expiry
  end

  def down
    add_column :dragoons, :perishable_token_expiry, :datetime
    add_column :dragoons, :perishable_token, :string
  end
end
