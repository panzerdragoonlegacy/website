json.array! @videos do |video|
  json.merge! video.attributes
end
