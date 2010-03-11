module Restfulie::Server::ActiveRecord::Base
  def to_atom(options={}, &block)         
    serializer = ::Restfulie::Server::ActiveRecord::Serializers::Atom.new(self, options, &block)
    block_given? ? serializer.atomify(options, &block) : serializer.atomify(options)
  end
end
ActiveRecord::Base.send(:include, Restfulie::Server::ActiveRecord::Base)
