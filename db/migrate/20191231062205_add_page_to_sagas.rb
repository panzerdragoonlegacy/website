class AddPageToSagas < ActiveRecord::Migration
  def change
    add_reference :sagas, :page, index: true
  end
end
