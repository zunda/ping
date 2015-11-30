json.array!(@ping_results) do |ping_result|
  json.extract! ping_result, :lag_ms, :distance_km
end
