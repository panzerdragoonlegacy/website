json.merge! @page.attributes
json.tags @tags do |tag|
  json.merge! tag.attributes
end
