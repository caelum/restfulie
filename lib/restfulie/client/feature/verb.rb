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
    request(:head, path, headers)
  end

  # POST HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def post(payload, options = {:recipe => nil})
    request(:post, path, payload, options.merge(headers))
  end

  # PATCH HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def patch(payload)
    request(:patch, path, payload, headers)
  end

  # PUT HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def put(payload)
    request(:put, path, payload, headers)
  end

  # DELETE HTTP verb without {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def delete
    request(:delete, path, headers)
  end

  # GET HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def get!(params = {})
    request!(:get, add_query_string(path, params), headers)
  end

  # HEAD HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def head!
    request!(:head, path, headers)
  end

  # POST HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def post!(payload, options = {:recipe => nil})
    request!(:post, path, payload, options.merge(headers))
  end

  # PATCH HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def patch!(payload)
    request!(:patch, path, payload, headers)
  end

  # PUT HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>payload: 'some text'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def put!(payload)
    request!(:put, path, payload, headers)
  end

  # DELETE HTTP verb {Error}
  # * <tt>path: '/posts'</tt>
  # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def delete!
    request!(:delete, path, headers)
  end

  protected

  def query_string(params)
    params = params.map { |param, value| "#{param}=#{value}"}.join("&")
    params.blank? ? "" : URI.escape("?#{params}")
  end
end