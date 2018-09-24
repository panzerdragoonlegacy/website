class AddSagaToCategory < ActiveRecord::Migration
  def change
    add_reference :categories, :saga, index: true
    add_column :categories, :short_name, :string
  end
end
