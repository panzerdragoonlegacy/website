class CreateRedirects < ActiveRecord::Migration
  def change
    create_table :redirects do |t|
      t.string :old_url
      t.string :new_url
      t.text :comment
      t.timestamps
    end
  end
end
