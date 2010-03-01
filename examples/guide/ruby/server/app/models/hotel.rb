class Hotel < ActiveRecord::Base
	acts_as_restfulie do |hotel, t|
	  t << [:update]
	  t << [:self, {:action => :show}]
  end
	media_type "vnd/caelum_hotel+xml", "vnd/caelum_hotel+json"
end
