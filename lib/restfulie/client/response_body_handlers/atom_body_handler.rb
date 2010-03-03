module Restfulie::Client::ResponseBodyHandler

  module AtomBodyHandler

    def self.unmarshal(response)
      ::Atom::Feed.load_feed(response.body)
    end

  end

  Base.register('application/atom+xml',AtomBodyHandler)

end
