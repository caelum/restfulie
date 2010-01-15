# an extesion to http responses
module Restfulie::Client::HTTPResponse
        
  # determines if this response code was successful (according to http specs: 200~299)
  def is_successful?
    code.to_i >= 200 && code.to_i <= 299
  end
    
  # determines if this response code was successful (according to http specs: 100~199)
  def is_informational?
    code.to_i >= 100 && code.to_i <= 199
  end
    
  # determines if this response code was successful (according to http specs: 300~399)
  def is_redirection?
    code.to_i >= 300 && code.to_i <= 399
  end
    
  # determines if this response code was successful (according to http specs: 400~499)
  def is_client_error?
    code.to_i >= 400 && code.to_i <= 499
  end
    
  # determines if this response code was successful (according to http specs: 500~599)
  def is_server_error?
    code.to_i >= 500 && code.to_i <= 599
  end
  
  def etag
    self['Etag']
  end

  def last_modified
    self['Last-Modified']
  end
    
end
