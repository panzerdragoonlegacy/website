json.array! @pictures do |picture|
  json.merge! picture.attributes
end
