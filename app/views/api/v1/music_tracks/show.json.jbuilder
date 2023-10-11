json.merge! @music_track.attributes
json.tags @tags do |tag|
  json.merge! tag.attributes
end
