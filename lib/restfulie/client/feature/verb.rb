module Restfulie::Client::Feature::Verb

  # GET HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def get(params = {})
    @verb = :get
    at query_string(params)
    request_flow
  end

  # HEAD HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def head
    @verb = :head
    request_flow
  end

  # POST HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def post(payload, options = {:recipe => nil})
    @verb = :post
    request_flow :body => payload
  end

  # PATCH HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def patch(payload)
    @verb = :patch
    request_flow :body => payload
  end

  # PUT HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def put(payload)
    @verb = :put
    request_flow :body => payload
  end

  # DELETE HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def delete
    @verb = :delete
    request_flow
  end

  # GET HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def get!(params = {})
    request :throw_error_request
    get params
  end

  # HEAD HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def head!
    request :throw_error_request
    head
  end

  # POST HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def post!(payload, options = {:recipe => nil})
    request :throw_error_request
    post payload
  end

  # PATCH HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def patch!(payload)
    request :throw_error_request
    patch payload
  end

  # PUT HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def put!(payload)
    request :throw_error_request
    put payload
  end

  # DELETE HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def delete!
    request :throw_error_request
    delete
  end

  protected

  def query_string(params)
    params = params.map { |param, value| "#{param}=#{value}"}.join("&")
    params.blank? ? "" : URI.escape("?#{params}")
  end
end