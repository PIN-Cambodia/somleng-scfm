module Filter
  module Resource
    class SensorRule < Filter::Resource::Base
      private

      def filter_params
        params.slice(:sensor_id)
      end
    end
  end
end
