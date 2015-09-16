json.array!(@ping_results) do |ping_result|
  json.extract! ping_result, :id, :lag_ms, :src_addr, :dst_addr, :src_city, :dst_city, :distance_km
  json.url ping_result_url(ping_result, format: :json)
end
