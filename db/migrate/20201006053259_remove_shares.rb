class RemoveShares < ActiveRecord::Migration[6.0]
  def change
    Category.where(category_type: 'share').delete_all
    CategoryGroup.where(category_group_type: 'share').delete_all
    drop_table :shares
  end
end
