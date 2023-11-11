class ChangeSequenceNumberDefault < ActiveRecord::Migration[7.0]
  def up
    change_column :pictures, :sequence_number, :integer, default: 1
    change_column :videos, :sequence_number, :integer, default: 1
    change_column :categorisations, :sequence_number, :integer, default: 1

    Picture.all.each do |picture|
      if picture.sequence_number == 0
        picture.sequence_number = 1
        picture.save
      end
    end

    Video.all.each do |video|
      if video.sequence_number == 0
        video.sequence_number = 1
        video.save
      end
    end

    Categorisation.all.each do |categorisation|
      if categorisation.sequence_number == 0
        categorisation.sequence_number = 1
        categorisation.save
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
