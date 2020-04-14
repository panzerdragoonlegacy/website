class AddSummaryToNewsEntries < ActiveRecord::Migration
  def change
    add_column :news_entries, :summary, :string
  end
end
