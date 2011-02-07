# ==== FollowLink follow new location of a document usually with response codes 201,301,302,303 and 307. You can also configure other codes.
# 
# ==== Example:
# @executor = ::Restfulie::Client::HTTP::FollowLinkExecutor.new("http://restfulie.com") #this class includes FollowLink module.
# @executor.at('/custom/songs').accepts('application/atom+xml').follow(201).post!("custom").code
class Restfulie::Client::Feature::FollowRequest
  
  def follow(code = nil)
    unless code.nil? or follow_codes.include?(code)
      follow_codes << code
    end
    self
  end

  def execute(flow, request, env)
    resp = flow.continue(request, env)
    if !resp.respond_to?(:code)
      return resp
    end
    
    if should_follow?(resp)
      follow_this resp, request
    else
      resp
    end
  end

  protected
  
  def should_follow?(response)
    code = response.code.to_i
    if code==201 && !response.body.empty?
      false
    else
      follow_codes.include?(code)
    end
  end
  
  def follow_this(response, request)
    location = extract_location(response)
    req = Restfulie.at(location)
    if accept = request.headers['Accept']
      req.accepts(accept)
    end
    req.get
  end

  def extract_location(response)
    location = response.response.headers['location'] || response.response.headers['Location']
    if location.nil?
      raise Restfulie::Client::HTTP::Error::AutoFollowWithoutLocationError.new(request, response)
    end
    location.first
  end
  
    def follow_codes
      @follow_codes ||= [201,301,302,303,307]        
    end
end
