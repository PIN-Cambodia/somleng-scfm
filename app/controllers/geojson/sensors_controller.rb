class Geojson::SensorsController < BaseController
  def index
    @sensors = Sensor.all
    @geojson = {}
    @geojson['type'] = 'FeatureCollection'
    @geojson['features'] = []

    @sensors.each do |sensor|
      @geojson['features'].push({
            type: "Feature",
            geometry: {
              type: 'Point',
              coordinates: [sensor.metadata['latitude'], sensor.metadata['longitude']]
            },
            properties: {
              name: sensor.province.name_en,
              status: sensor.metadata['status'],
              type: sensor.metadata['type']
            }
          })
    end
    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end
  end
end
