class RemoveUnusedColumnsFromDragoons < ActiveRecord::Migration
  def up
    remove_column :dragoons, :time_zone
    remove_column :dragoons, :birthday
    remove_column :dragoons, :gender
    remove_column :dragoons, :country
    remove_column :dragoons, :information
    remove_column :dragoons, :favourite_quotations
    remove_column :dragoons, :occupation
    remove_column :dragoons, :interests
    remove_column :dragoons, :xbox_live_gamertag
    remove_column :dragoons, :playstation_network_online_id
    remove_column :dragoons, :wii_number
    remove_column :dragoons, :steam_username
    remove_column :dragoons, :yahoo_id
    remove_column :dragoons, :aim_screenname
    remove_column :dragoons, :icq_number
    remove_column :dragoons, :jabber_id
    remove_column :dragoons, :skype_name
  end

  def down
    add_column :dragoons, :skype_name, :string
    add_column :dragoons, :jabber_id, :string
    add_column :dragoons, :icq_number, :string
    add_column :dragoons, :aim_screenname, :string
    add_column :dragoons, :yahoo_id, :string
    add_column :dragoons, :steam_username, :string
    add_column :dragoons, :wii_number, :string
    add_column :dragoons, :playstation_network_online_id, :string
    add_column :dragoons, :xbox_live_gamertag, :string
    add_column :dragoons, :interests, :string
    add_column :dragoons, :occupation, :string
    add_column :dragoons, :favourite_quotations, :text
    add_column :dragoons, :information, :text
    add_column :dragoons, :country, :string
    add_column :dragoons, :gender, :string
    add_column :dragoons, :birthday, :date
    add_column :dragoons, :time_zone, :string
  end
end
