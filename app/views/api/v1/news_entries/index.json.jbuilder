json.array! @news_entries do |news_entry|
  json.merge! news_entry.attributes
end
