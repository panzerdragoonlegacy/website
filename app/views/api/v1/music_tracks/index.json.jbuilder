json.array! @music_tracks do |music_track|
  json.merge! music_track.attributes
end
