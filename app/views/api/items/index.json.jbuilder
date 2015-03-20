json.array!(@items) do |item|
  json.id    item.id
  json.title item.title
  json.thumb item.image(:thumb)
  json.image item.image(:original)
  json.release_date item.release_date
end