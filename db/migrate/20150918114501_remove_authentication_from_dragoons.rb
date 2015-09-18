class RemoveAuthenticationFromDragoons < ActiveRecord::Migration
  def up
    remove_column :dragoons, :password_digest
    remove_column :dragoons, :remember_token
    remove_column :dragoons, :role
  end

  def down
    add_column :dragoons, :role, :string
    add_column :dragoons, :password_digest, :string
    add_column :dragoons, :remember_token, :string
  end
end
