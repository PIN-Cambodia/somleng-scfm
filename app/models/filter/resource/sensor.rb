class Filter::Resource::Sensor < Filter::Resource::Base
  private

  def filter_params
    params.slice(:external_id)
  end


  # def self.search(search)
  #   if search
  #     find(:all, :conditions => ['Province LIKE ?',"%#{search}%"])
  #   else
  #     find(:all)  
  # 	end
  # end
end
