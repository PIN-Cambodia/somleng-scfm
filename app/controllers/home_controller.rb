class HomeController < ApplicationController
  layout "home"

  def index;
    @contacts = Contact.count()
  	@sensors = Sensor.where('metadata @> ?', {status: 'active'}.to_json).count()
    # Old system had 206216 callouts, so we add this manually here.
  	@call_participation = CalloutParticipation.count() + 206216


  end
end
