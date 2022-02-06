class AddSlugIdPrefixesToMarkdownLinks < ActiveRecord::Migration
  def up
    NewsEntry.all.each do |news_entry|
      Download.all.each do |download|
        if news_entry.content.include? "](/downloads/#{download.url})"
          news_entry.content.gsub!(
            %r{\(\/downloads\/#{download.url}\)},
            "(/downloads/#{download.id.to_s}-#{download.url})"
          )
          news_entry.save
        end
      end

      Picture.all.each do |picture|
        if news_entry.content.include? "](/pictures/#{picture.url})"
          news_entry.content.gsub!(
            %r{\(\/pictures\/#{picture.url}\)},
            "(/pictures/#{picture.id.to_s}-#{picture.url})"
          )
          news_entry.save
        end

        if news_entry.content.include? "![](#{picture.url}.jpg)"
          news_entry.content.gsub!(
            /\(#{picture.url}.jpg\)/,
            "(#{picture.id.to_s}-#{picture.url}.jpg)"
          )
          news_entry.save
        end
      end

      MusicTrack.all.each do |music_track|
        if news_entry.content.include? "](/music/#{music_track.url})"
          news_entry.content.gsub!(
            %r{\(\/music\/#{music_track.url}\)},
            "(/music/#{music_track.id.to_s}-#{music_track.url})"
          )
          news_entry.save
        end

        if news_entry.content.include? "![](#{music_track.url}.mp3)"
          news_entry.content.gsub!(
            /\(#{music_track.url}.mp3\)/,
            "(#{music_track.id.to_s}-#{music_track.url}.mp3)"
          )
          news_entry.save
        end
      end

      Resource.all.each do |resource|
        if news_entry.content.include? "](/resources/#{resource.url})"
          news_entry.content.gsub!(
            %r{\(\/resources\/#{resource.url}\)},
            "(/resources/#{resource.id.to_s}-#{resource.url})"
          )
          news_entry.save
        end
      end

      Video.all.each do |video|
        if news_entry.content.include? "](/videos/#{video.url})"
          news_entry.content.gsub!(
            %r{\(\/videos\/#{video.url}\)},
            "(/videos/#{video.id.to_s}-#{video.url})"
          )
          news_entry.save
        end

        if news_entry.content.include? "![](#{video.url}.mp4)"
          news_entry.content.gsub!(
            /\(#{video.url}.mp4\)/,
            "(#{video.id.to_s}-#{video.url}.mp4)"
          )
          news_entry.save
        end
      end
    end
  end

  def down
    NewsEntry.all.each do |news_entry|
      Video.all.each do |video|
        if news_entry.content.include? "![](#{video.id.to_s}-#{video.url}.jpg)"
          news_entry.content.gsub!(
            /\(#{video.id.to_s}-#{video.url}.mp4\)/,
            "(#{video.url}.mp4)"
          )
          news_entry.save
        end

        if news_entry.content.include?(
             "](/videos/#{video.id.to_s}-#{video.url})"
           )
          news_entry.content.gsub!(
            %r{\(\/videos\/#{video.id.to_s}-#{video.url}\)},
            "(/videos/#{video.url})"
          )
          news_entry.save
        end
      end

      Resource.all.each do |resource|
        if news_entry.content.include?(
             "](/resources/#{resource.id.to_s}-#{resource.url})"
           )
          news_entry.content.gsub!(
            %r{\(\/resources\/#{resource.id.to_s}-#{resource.url}\)},
            "(/resources/#{resource.url})"
          )
          news_entry.save
        end
      end

      MusicTrack.all.each do |music_track|
        if news_entry.content.include?(
             "![](#{music_track.id.to_s}-#{music_track.url}.jpg)"
           )
          news_entry.content.gsub!(
            /\(#{music_track.id.to_s}-#{music_track.url}.mp3\)/,
            "(#{music_track.url}.mp3)"
          )
          news_entry.save
        end

        if news_entry.content.include?(
             "](/music/#{music_track.id.to_s}-#{music_track.url})"
           )
          news_entry.content.gsub!(
            %r{\(\/music\/#{music_track.id.to_s}-#{music_track.url}\)},
            "(/music/#{music_track.url})"
          )
          news_entry.save
        end
      end

      Picture.all.each do |picture|
        if news_entry.content.include?(
             "![](#{picture.id.to_s}-#{picture.url}.jpg)"
           )
          news_entry.content.gsub!(
            /\(#{picture.id.to_s}-#{picture.url}.jpg\)/,
            "(#{picture.url}.jpg)"
          )
          news_entry.save
        end

        if news_entry.content.include?(
             "](/pictures/#{picture.id.to_s}-#{picture.url})"
           )
          news_entry.content.gsub!(
            %r{\(\/pictures\/#{picture.id.to_s}-#{picture.url}\)},
            "(/pictures/#{picture.url})"
          )
          news_entry.save
        end
      end

      Download.all.each do |download|
        if news_entry.content.include?(
             "](/downloads/#{download.id.to_s}-#{download.url})"
           )
          news_entry.content.gsub!(
            %r{\(\/downloads\/#{download.id.to_s}-#{download.url}\)},
            "(/downloads/#{download.url})"
          )
          news_entry.save
        end
      end
    end
  end
end
