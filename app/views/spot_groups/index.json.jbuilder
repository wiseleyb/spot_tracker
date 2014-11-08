json.array!(@spot_groups) do |spot_group|
  json.extract! spot_group, :id, :name
  json.url spot_group_url(spot_group, format: :json)
end
