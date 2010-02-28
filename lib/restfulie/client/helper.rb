module Restfulie::Client::Helper
  # retrieves the invoking method's name
  def self.current_method
    caller[0]=~/`(.*?)'/
    $1
  end
end
