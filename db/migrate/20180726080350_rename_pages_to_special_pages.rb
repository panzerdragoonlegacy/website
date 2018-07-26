class RenamePagesToSpecialPages < ActiveRecord::Migration
  def change
    rename_table :pages, :special_pages
  end
end
