json.featured_news_entry { json.merge! @featured_news_entry.attributes }
json.pictures @pictures do |picture|
  json.merge! picture.attributes
end
json.page { json.merge! @page.attributes }
json.music_track { json.merge! @music_track.attributes }
json.video { json.merge! @video.attributes }
json.download { json.merge! @download.attributes }
json.news_entries @news_entries do |news_entry|
  json.merge! news_entry.attributes
end
