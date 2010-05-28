# inject new behavior in Atom instances to enable easily access to link relationships.
class Hash
  include Restfulie::Client::HTTP::LinkRequestBuilder
end
