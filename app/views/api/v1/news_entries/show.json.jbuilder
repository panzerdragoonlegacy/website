json.merge! @news_entry.attributes
json.tags @tags do |tag|
  json.merge! tag.attributes
end
