module Restfulie::Client::HTTP#:nodoc:
  
  # Offers a way to access Atom entries element's in namespaced extensions.
  module AtomElementShortcut
    def method_missing(method_sym,*args)
      return super(method_sym, *args) unless simple_extensions
      
      found = find_extension_entry_for(method_sym)
      return super(method_sym, *args) if found.empty?
      result = found.collect do |pair|
        pair.last.length==1 ? pair.last.first : pair.last
      end
      result.length==1 ? result.first : result
    end
    
    def respond_to?(method_sym)
      return super(method_sym) unless simple_extensions

      found = find_extension_entry_for(method_sym)
      (found.length!=0) || super(method_sym)
    end
    
    private
    def find_extension_entry_for(method_sym)
      start = -(method_sym.to_s.length + 1)
      found = simple_extensions.select do |k, v|
        method_sym.to_s == k[start..-2]
      end
    end
  end
  
  # Offers a way to access Atom entries element's in namespaced extensions.
  module AtomElementShortcut
    def method_missing(method_sym,*args)
      return super(method_sym, *args) unless simple_extensions
      
      start = -(method_sym.to_s.length + 1)
      found = simple_extensions.select do |k, v|
        method_sym.to_s == k[start..-2]
      end
      return super(method_sym, *args) if found.empty?
      result = found.collect do |pair|
        pair.last.length==1 ? pair.last.first : pair.last
      end
      result.length==1 ? result.first : result
    end
  end

  # inject new behavior in rAtom instances to enable easily access to link relationships.
  ::Atom::Feed.instance_eval {
    include Restfulie::Client::LinkShortcut
    include AtomElementShortcut
  }
  ::Atom::Entry.instance_eval {
    include Restfulie::Client::LinkShortcut
    include AtomElementShortcut
  }
  ::Atom::Link.instance_eval {
    include Restfulie::Client::HTTP::LinkRequestBuilder
  }
  
end


class Atom::Link
  def content_type
    type
  end
end
