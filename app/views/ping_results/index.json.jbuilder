json.array!(@ping_results) do |ping_result|
  json.extract! ping_result, :id, :lag_ms, :src_addr, :user_agent, :location_id, :server_location_id
  json.url ping_result_url(ping_result, format: :json)
end
