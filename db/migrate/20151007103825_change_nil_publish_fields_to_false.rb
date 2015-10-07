class ChangeNilPublishFieldsToFalse < ActiveRecord::Migration
  def up
    Article.all.each do |article|
      if article.publish.blank?
        article.publish = false
        article.save
      end
    end

    Category.all.each do |category|
      if category.publish.blank?
        category.publish = false
        category.save
      end
    end

    Chapter.all.each do |chapter|
      if chapter.publish.blank?
        chapter.publish = false
        chapter.save
      end
    end

    Download.all.each do |download|
      if download.publish.blank?
        download.publish = false
        download.save
      end
    end

    EncyclopaediaEntry.all.each do |encyclopaedia_entry|
      if encyclopaedia_entry.publish.blank?
        encyclopaedia_entry.publish = false
        encyclopaedia_entry.save
      end
    end

    MusicTrack.all.each do |music_track|
      if music_track.publish.blank?
        music_track.publish = false
        music_track.save
      end
    end

    NewsEntry.all.each do |news_entry|
      if news_entry.publish.blank?
        news_entry.publish = false
        news_entry.save
      end
    end

    Page.all.each do |page|
      if page.publish.blank?
        page.publish = false
        page.save
      end
    end

    Picture.all.each do |picture|
      if picture.publish.blank?
        picture.publish = false
        picture.save
      end
    end

    Poem.all.each do |poem|
      if poem.publish.blank?
        poem.publish = false
        poem.save
      end
    end

    Quiz.all.each do |quiz|
      if quiz.publish.blank?
        quiz.publish = false
        quiz.save
      end
    end

    Resource.all.each do |resource|
      if resource.publish.blank?
        resource.publish = false
        resource.save
      end
    end

    Story.all.each do |story|
      if story.publish.blank?
        story.publish = false
        story.save
      end
    end

    Video.all.each do |video|
      if video.publish.blank?
        video.publish = false
        video.save
      end
    end    
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
