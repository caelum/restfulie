require 'time'

# an extesion to http responses
module Restfulie::Client::HTTP::ResponseStatus
  
  attr_accessor :previous
        
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
  
module Restfulie::Client::HTTP::ResponseCacheCheck

  def cache_max_age
    val = header_value_from('Cache-control', /^\s*max-age=(\d+)/)
    if val
      val.to_i
    else
      0
    end
  end
  
  def header_value_from(header, expression)
    h = value_for(get_fields(header)[0], expression)
    return nil if h.nil?
    h.match(expression)[1]
  end
  
  def has_expired_cache?
    return true if self['Date'].nil?
    Time.now > Time.rfc2822(self['Date']) + cache_max_age.seconds
  end

  # checks if the header's max-age is available and no no-store if available.
  def may_cache?
    may_cache_field?(headers['cache-control'])
  end
  
  # Returns whether this cache control field allows caching
  #
  # may_cache_field(['max-age=2000', 'no-store']) == false
  # may_cache_field('max-age=2000,no-store') == false
  # may_cache_field('max-age=2000') == true
  def may_cache_field?(field)
    return false if field.nil?
    
    debugger
    if field.kind_of? Array
      field.each do |f|
        return false if !may_cache_field?(f)
      end
      return true
    end

    max_age_header = value_for(field, /^max-age=(\d+)/)
    return false if max_age_header.nil?
    max_age = max_age_header[1]
    
    return false if value_for(field, /^no-store/)
    
    true
  end

  # extracts the header value for an specific expression, which can be located at the start or in the middle
  # of the expression
  def value_for(value, expression)
    value.split(",").find { |obj| obj.strip =~ expression }
  end
  
  # extracts all header values related to the Vary header from this response, in order
  # to implement Vary support from the HTTP Specification
  # 
  # example
  # if the response Vary header is 'Accept','Accept-Language', we have
  # vary_headers_for({'Accept'=>'application/xml', 'Date' =>'...', 'Accept-Language'=>'de'}) == ['application/xml', 'de']
  # vary_headers_for({'Date' => '...', 'Accept-Language'=>'de'}) == [nil, 'de']
  def vary_headers_for(request)
    return nil if self['Vary'].nil?
    self['Vary'].split(',').map do |key|
      request[key.strip]
    end
  end
    
end

class Restfulie::Client::HTTP::Response
  include Restfulie::Client::HTTP::ResponseStatus
  include Restfulie::Client::HTTP::ResponseCacheCheck
end
