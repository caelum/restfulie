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
    code = resp.code.to_i
    if follow_codes.include?(code)
      if code==201 && !resp.body.empty?
        resp
      else
        location = resp.response.headers['location'] || resp.response.headers['Location']
        raise Error::AutoFollowWithoutLocationError.new(request, resp) unless location
        # use the first location available
        location = location[0]
        Restfulie.at(location).accepts(request.headers['Accept']).get
      end
    else
      resp
    end
  end

  protected

    def follow_codes
      @follow_codes ||= [201,301,302,303,307]        
    end
end
