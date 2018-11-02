class HomeController < ApplicationController
  layout "home"

  def index; 
    @contacts = Contact.count()
  	@sensors = Sensor.count()
  	@call_participation = CalloutParticipation.count() + 10000
  	

  end

end
