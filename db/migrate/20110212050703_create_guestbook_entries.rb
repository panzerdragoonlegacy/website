class CreateGuestbookEntries < ActiveRecord::Migration
  def self.up
    create_table :guestbook_entries do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.string :country
      t.text :favourite_games
      t.text :who_would_win
      t.text :comments
      t.string :email_address
      t.string :website
      t.timestamps
    end
  end

  def self.down
    drop_table :guestbook_entries
  end
end
