json.merge! @contributor_profile.attributes
json.tags @tags do |tag|
  json.merge! tag.attributes
end
