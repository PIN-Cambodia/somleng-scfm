require "rails_helper"

RSpec.describe "GeoJSON" do
  let(:admin) { create(:admin) }

  it "can list sensors" do
    sensor = create(
      :sensor,
      account: admin.account,
      commune_ids: ["040101"],
      metadata: {
        latitude: 104.163297,
        longitude: 10.677273
      }
    )

    get(geojson_sensors_path)
    expect(response.code).to eq("200")
    parsed_body = JSON.parse(response.body)
    expect(parsed_body.fetch("type")).to eq 'FeatureCollection'
    expect(parsed_body.fetch("features").size).to eq 1
    expect(parsed_body.fetch("features").first.fetch("geometry").fetch('coordinates')).to eq [104.163297,10.677273]
  end
end

def response_body
  JSON.parse(response.body)
end
