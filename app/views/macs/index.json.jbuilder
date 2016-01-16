json.array!(@macs) do |mac|
  json.extract! mac, :id, :address
  json.url mac_url(mac, format: :json)
end
