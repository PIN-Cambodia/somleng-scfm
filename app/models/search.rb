class Search < ApplicationRecord

  def self.search(search)
    if search
      where('Province LIKE ?',"%{search}%")
      # find(:all, :conditions => ['Province LIKE ?',"%#{search}%"])
    else
      # find(:all)  
      all
  	end
  end

end
