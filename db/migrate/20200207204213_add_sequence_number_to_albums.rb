class AddSequenceNumberToAlbums < ActiveRecord::Migration
  def change
    add_column :pictures, :sequence_number, :integer, default: 0
    add_column :videos, :sequence_number, :integer, default: 0
  end
end
