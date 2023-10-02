json.merge! @category.attributes
json.categorisations @category.ordered_categorisations do |categorisation|
  json.merge! categorisation.attributes
  json.subcategory categorisation.subcategory.attributes
end
json.literature_pages @literature_pages do |page|
  json.merge! page.attributes
end
json.pictures @pictures do |picture|
  json.merge! picture.attributes
end
json.music_tracks @music_tracks do |music_track|
  json.merge! music_track.attributes
end
json.videos @videos do |video|
  json.merge! video.attributes
end
json.downloads @downloads do |download|
  json.merge! download.attributes
end
