class CreateDragoons < ActiveRecord::Migration
  def self.up
    create_table :dragoons do |t|
      t.string :name
      t.string :url
      t.string :email_address
      t.string :password_digest
      t.string :remember_token
      t.string :perishable_token
      t.datetime :perishable_token_expiry
      t.string :time_zone
      t.string :role, :default => :guest.to_s
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.date :birthday
      t.string :gender
      t.string :country
      t.text :information
      t.text :favourite_quotations
      t.string :occupation
      t.string :interests
      t.string :website
      t.string :facebook_username
      t.string :twitter_username
      t.string :xbox_live_gamertag
      t.string :playstation_network_online_id
      t.string :wii_number
      t.string :steam_username
      t.string :windows_live_id
      t.string :yahoo_id
      t.string :aim_screenname
      t.string :icq_number
      t.string :jabber_id
      t.string :skype_name
      t.timestamps
    end
  end

  def self.down
    drop_table :dragoons
  end
end