class SetSlugFieldsWithParameterize < ActiveRecord::Migration[7.0]
  def up
    [
      Album,
      CategoryGroup,
      Category,
      ContributorProfile,
      Download,
      MusicTrack,
      NewsEntry,
      Page,
      Picture,
      Quiz,
      Saga,
      Tag,
      Video
    ].each do |klass|
      puts "Looping through #{klass}"
      klass.all.each do |record|
        puts "Saving record: #{record.id} #{record.name}"
        record.slug = record.slug_from_name
        record.save!
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
