module Filter
  module Resource
    class Sensor < Filter::Resource::Base
      private

      def filter_params
        params.slice(:external_id)
      end
    end
  end
end
