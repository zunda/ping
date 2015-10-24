json.array!(@locations) do |location|
  json.extract! location, :id, :host, :latitude, :longitude, :city
  json.url location_url(location, format: :json)
end
