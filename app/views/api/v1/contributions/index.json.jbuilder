json.array! @pictures do |picture|
  json.merge! picture.attributes
end
json.array! @pages do |page|
  json.merge! page.attributes
end
json.array! @music_tracks do |music_track|
  json.merge! music_track.attributes
end
json.array! @videos do |video|
  json.merge! video.attributes
end
json.array! @downloads do |download|
  json.merge! download.attributes
end
