class Geojson::SensorsController < BaseController
  def index
    sensors = Sensor.all
    geojson = {}
    geojson['type'] = 'FeatureCollection'
    geojson['features'] = []

    sensors.each do |sensor|
      # Ignore other sensor types for now
      if sensor.metadata['type'] != 'bridge'
        next
      end
      # Set up basic information about the sensor
      trigger_levels = {
        severe_warning: sensor.metadata['riverbed_to_severe_warning'].to_f,
        warning: sensor.metadata['riverbed_to_warning'].to_f,
        watch: sensor.metadata['riverbed_to_watch'].to_f,
      }

      geojson['features'].push({
        type: "Feature",
        geometry: {
          type: 'Point',
          coordinates: [sensor.metadata['longitude'].to_f, sensor.metadata['latitude'].to_f]
        },
        properties: {
          name: sensor.province.name_en,
          external_id: sensor.external_id,
          id: sensor.id,
          water_level: water_level(sensor),
          status: sensor_status(sensor, trigger_levels),
          type: sensor.metadata['type'],
          trigger_levels: trigger_levels.presence || nil
        }
      })
    end

    respond_to do |format|
      format.json { render json: geojson.to_json, content_type: 'application/json' }  # respond with the created JSON object
    end
  end

  def sensor_status(sensor, trigger_levels)
    status = sensor.metadata['status']
    last_event = sensor.sensor_events.last

    # if we havent gotten a reading in 24 hours, set sensor to inactive
    if !last_event.present? || last_event.created_at < 1.days.ago
      status = 'inactive'
    # Get latest measurement and compare with latest reading to ensure proper status
    elsif status == 'active' && sensor.metadata['riverbed_to_sensor'].present?
      # If we have a water_height and we have the warning levels set, update the status
      if water_level(sensor) >= trigger_levels[:severe_warning]
        status = 'severe_warning'
      elsif water_level(sensor) >= trigger_levels[:warning]
        status = 'warning'
      elsif water_level(sensor) >= trigger_levels[:watch]
        status = 'watch'
      end
    end
    return status
  end

  def water_level(sensor)
    last_event = sensor.sensor_events.last
    if last_event.nil?
      return nil
    end
    water_level = sensor.metadata['riverbed_to_sensor'].to_f - last_event.payload['distance'].to_f
    # Old sensor format - sensor height is hardcoded in the firmware, so it reports water_height directly, but is harder to update
    if last_event.payload['streamHeight'].present?
      water_level = last_event.payload['streamHeight'].to_f
    end
    return water_level
  end
end
