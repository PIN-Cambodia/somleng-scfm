class Datapoints::SensorEventsController < BaseController
  def index
    @external_id = params[:external_id]
    @startDate = params[:start]
    @endDate = params[:end]
    @sensor = Sensor.find_by(external_id: @external_id)
    @sensor_events = SensorEvent.where(sensor: @sensor.id, created_at: @startDate..@endDate)

    @json = []

    @sensor_events.each do |sensor_event|
      @json.push({
        value: [sensor_event.created_at, water_level(@sensor, sensor_event)]
      })
    end

    respond_to do |format|
      format.json { render json: @json.to_json, content_type: 'application/json' }  # respond with the created JSON object
    end

  end

  def water_level(sensor, event)
    if event.nil?
      return nil
    end
    water_level = sensor.metadata['riverbed_to_sensor'].to_f - event.payload['distance'].to_f
    # Old sensor format - sensor height is hardcoded in the firmware, so it reports water_height directly, but is harder to update
    if event.payload['streamHeight'].present?
      water_level = event.payload['streamHeight'].to_f
    end
    # A bit of cleanup to avoid looking super stupid if the sensor sends wrong data
    if(water_level < 0)
      water_level = 0
    end
    return water_level
  end
end
