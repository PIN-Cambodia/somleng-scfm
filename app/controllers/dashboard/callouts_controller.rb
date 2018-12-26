module Dashboard
  class CalloutsController < Dashboard::BaseController
    helper_method :callout_summary

    private

    def prepare_resource_for_new
      resource.call_flow_logic ||= Callout::DEFAULT_CALL_FLOW_LOGIC
    end

    def prepare_resource_for_create
      build_callout_population
      resource.created_by ||= current_user
      resource.subscribe(CalloutObserver.new)
    end

    def prepare_resource_for_update
      if resource.callout_population.blank?
        build_callout_population
      else
        resource.callout_population.contact_filter_params = contact_filter_params
      end
    end

    def association_chain
      current_account.callouts
    end

    def permitted_params
      params.require(:callout).permit(
        :call_flow_logic,
        :audio_file,
        :audio_url,
        commune_ids: []
      )
    end

    def build_callout_population
      resource.build_callout_population(
        account: current_account,
        contact_filter_params: contact_filter_params
      )
    end

    def contact_filter_params
      { has_locations_in: resource.commune_ids.reject(&:blank?) }
    end

    def callout_summary
      @callout_summary ||= CalloutSummary.new(resource)
    end
  end
end
