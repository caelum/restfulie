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

  def execute(flow, request, response, env)
    resp = flow.continue(request, response, env)
    if follow_codes.include?(resp.code.to_i)
      location = resp.response.headers['location'] || resp.response.headers['Location']
      raise Error::AutoFollowWithoutLocationError.new(request, resp) unless location
      # use the first location available
      location = location[0]
      Restfulie.debug.at(location).get
    else
      resp
    end
  end

  protected

    def follow_codes
      @follow_codes ||= [201,301,302,303,307]        
    end
end
