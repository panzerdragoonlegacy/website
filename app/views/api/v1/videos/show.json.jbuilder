json.merge! @video.attributes
json.tags @tags do |tag|
  json.merge! tag.attributes
end
