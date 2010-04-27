# Copyright (c) 2008 The Kaphan Foundation
#
# For licensing information see LICENSE.txt.
#
# Please visit http://www.peerworks.org/contact for further information.
#

require 'forwardable'
require 'delegate'
require 'rubygems'
gem 'libxml-ruby', '>= 1.1.2'
require 'xml/libxml'
require File.dirname(__FILE__) +'/atom/xml/parser.rb'

module Atom # :nodoc:
  NAMESPACE = 'http://www.w3.org/2005/Atom' unless defined?(NAMESPACE)
  module Pub
    NAMESPACE = 'http://www.w3.org/2007/app'
  end
  
  # Raised when a Serialization Error occurs.
  class SerializationError < StandardError; end
  
  # Provides support for reading and writing simple extensions as defined by the Atom Syndication Format.
  #
  # A Simple extension is an element from a non-atom namespace that has no attributes and only contains
  # text content. It is interpreted as a key-value pair when the namespace and the localname of the
  # extension make up the key. Since in XML you can have many instances of an element, the values are
  # represented as an array of strings, so to manipulate the values manipulate the array returned by
  # +[ns, localname]+.
  #
  module SimpleExtensions
    attr_reader :simple_extensions

    # Gets a simple extension value for a given namespace and local name.
    #
    # +ns+:: The namespace.
    # +localname+:: The local name of the extension element.
    #
    def [](namespace, localname=nil)
      @simple_extensions ||= {}

      localname.nil? ? namespace_hash(namespace) : element_values(namespace, localname)
    end

  protected

    def namespace_hash(namespace)
      namespace_keys = @simple_extensions.keys.select { |key| key =~ /^\{#{namespace},/ }

      elements = {}
      namespace_keys.each do |key|
        attribute_name = key.match(/\{.*,(.*)\}/)[1]
        elements[attribute_name] = @simple_extensions[key]
      end
      elements
    end

    def element_values(namespace, localname)
      key = "{#{namespace},#{localname}}"
      @simple_extensions[key] ||= ValueProxy.new
    end
    
    class ValueProxy < DelegateClass(Array)
      attr_accessor :as_attribute
      def initialize
        super([])
        @as_attribute = false
      end
    end
  end
  
  # Represents a Generator as defined by the Atom Syndication Format specification.
  #
  # The generator identifies an agent or engine used to a produce a feed.
  #
  # See also http://www.atomenabled.org/developers/syndication/atom-format-spec.php#element.generator
  class Generator
    include Xml::Parseable
    
    attr_accessor :name
    attribute :uri, :version
    
    # Initialize a new Generator.
    #
    # +xml+:: An XML::Reader object.
    #
    def initialize(o = {})
      case o
      when XML::Reader
        @name = o.read_string.strip
        parse(o, :once => true)
      when Hash
        o.each do |k, v|
          self.send("#{k.to_s}=", v)
        end
      else
        raise ArgumentError, "Got #{o.class} but expected a Hash or XML::Reader"
      end
      
      yield(self) if block_given?
    end
    
    def to_xml(nodeonly = true, name = 'generator', namespace = nil, namespace_map = Atom::Xml::NamespaceMap.new)
      node = XML::Node.new("#{namespace_map.prefix(Atom::NAMESPACE, name)}")
      node << @name if @name
      node['uri'] = @uri if @uri
      node['version'] = @version if @version
      node
    end
  end
    
  # Represents a Category as defined by the Atom Syndication Format specification.
  #
  #   
  class Category
    include Atom::Xml::Parseable
    include SimpleExtensions
    attribute :label, :scheme, :term
    
    def initialize(o = {})
      case o
      when XML::Reader
        parse(o, :once => true)
      when Hash
        o.each do |k, v|
          self.send("#{k.to_s}=", v)
        end
      else
        raise ArgumentError, "Got #{o.class} but expected a Hash or XML::Reader"
      end
      
      yield(self) if block_given?
    end
  end
  
  # Represents a Person as defined by the Atom Syndication Format specification.
  #
  # A Person is used for all author and contributor attributes.
  #
  # See also http://www.atomenabled.org/developers/syndication/atom-format-spec.php#atomPersonConstruct
  #
  class Person
    include Xml::Parseable
    element :name, :uri, :email
   
    # Initialize a new person.
    #
    # +o+:: An XML::Reader object or a hash. Valid hash keys are +:name+, +:uri+ and +:email+.
    def initialize(o = {})
      case o
      when XML::Reader
        o.read
        parse(o)
      when Hash
        o.each do |k, v|
          self.send("#{k.to_s}=", v)
        end
      else
        raise ArgumentError, "Got #{o.class} but expected a Hash or XML::Reader"
      end
      
      yield(self) if block_given?
    end
    
    def inspect
      "<Atom::Person name:'#{name}' uri:'#{uri}' email:'#{email}"
    end
  end
    
  class Content  # :nodoc:
    def self.parse(xml)
      case xml['type']
      when "xhtml"
        Xhtml.new(xml)
      when "html"
        Html.new(xml)
      else
        Text.new(xml)
      end
    end
  
    # This is the base class for all content within an atom document.
    #
    # Content can be Text, Html or Xhtml.
    #
    # A Content object can be treated as a String with type and xml_lang
    # attributes.
    #
    # For a thorough discussion of atom content see 
    # http://www.atomenabled.org/developers/syndication/atom-format-spec.php#element.content
    class Base < DelegateClass(String)
      include Xml::Parseable
            
      def initialize(c)
        __setobj__(c)
      end
      
      def ==(o)
        if o.is_a?(self.class)
          self.type == o.type &&
           self.xml_lang == o.xml_lang &&
           self.to_s == o.to_s
        elsif o.is_a?(String)
          self.to_s == o
        end
      end
            
      protected
      def set_content(c) # :nodoc:
        __setobj__(c)
      end
    end
    
    # Text content within an Atom document.
    class Text < Base      
      attribute :type, :'xml:lang'
      def initialize(o)
        case o
        when String
          super(o)
          @type = "text"
        when XML::Reader
          super(o.read_string)
          parse(o, :once => true)
        else
          raise ArgumentError, "Got #{o} which isn't a String or XML::Reader"
        end        
      end
      
      def to_xml(nodeonly = true, name = 'content', namespace = nil, namespace_map = Atom::Xml::NamespaceMap.new)
        node = XML::Node.new("#{namespace_map.prefix(Atom::NAMESPACE, name)}")
        node << self.to_s
        node
      end
    end
    
    # Html content within an Atom document.
    class Html < Base      
      attribute :type, :'xml:lang'
      # Creates a new Content::Html.
      #
      # +o+:: An XML::Reader or a HTML string.
      #
      def initialize(o)
        case o
        when XML::Reader
          super(o.read_string)
          parse(o, :once => true)
        when String
          super(o)
          @type = 'html'
        else
          raise ArgumentError, "Got #{o} which isn't a String or XML::Reader"
        end        
      end
      
      def to_xml(nodeonly = true, name = 'content', namespace = nil, namespace_map = Atom::Xml::NamespaceMap.new) # :nodoc:
        require 'iconv'
        # Convert from utf-8 to utf-8 as a way of making sure the content is UTF-8.
        #
        # This is a pretty crappy way to do it but if we don't check libxml just
        # fails silently and outputs the content element without any content. At
        # least checking here and raising an exception gives the caller a chance
        # to try and recitfy the situation.
        #
        begin
          node = XML::Node.new("#{namespace_map.prefix(Atom::NAMESPACE, name)}")
          node << Iconv.iconv('utf-8', 'utf-8', self.to_s)
          node['type'] = 'html'
          node['xml:lang'] = self.xml_lang if self.xml_lang
          node
        rescue Iconv::IllegalSequence => e
          raise SerializationError, "Content must be converted to UTF-8 before attempting to serialize to XML: #{e.message}."
        end
      end
    end
    
    # XHTML content within an Atom document.
    class Xhtml < Base
      XHTML = 'http://www.w3.org/1999/xhtml'      
      attribute :type, :'xml:lang'
      
      def initialize(o)
        case o
        when String
          super(o)
          @type = "xhtml"
        when XML::Reader
          super("")   
          xml = o
          parse(xml, :once => true)
          starting_depth = xml.depth

          # Get the next element - should be a div according to the atom spec
          while xml.read && xml.node_type != XML::Reader::TYPE_ELEMENT; end        

          if xml.local_name == 'div' && xml.namespace_uri == XHTML        
            set_content(xml.read_inner_xml.strip.gsub(/\s+/, ' '))
          else
            set_content(xml.read_outer_xml)
          end

          # get back to the end of the element we were created with
          while xml.read == 1 && xml.depth > starting_depth; end
        else
          raise ArgumentError, "Got #{o} which isn't a String or XML::Reader" 
        end
      end
      
      def to_xml(nodeonly = true, name = 'content', namespace = nil, namespace_map = Atom::Xml::NamespaceMap.new)
        node = XML::Node.new("#{namespace_map.prefix(Atom::NAMESPACE, name)}")
        node['type'] = 'xhtml'
        node['xml:lang'] = self.xml_lang.to_s

        parser = XML::HTMLParser.string("<div>#{to_s}</div>")
        div = parser.parse.root.first.first.copy(true)
        div['xmlns'] = XHTML
        
        node << div
        node
      end
    end
  end
   
  # Represents a Source as defined by the Atom Syndication Format specification.
  #
  # See also http://www.atomenabled.org/developers/syndication/atom-format-spec.php#element.source
  class Source
    extend Forwardable
    def_delegators :@links, :alternate, :self, :alternates, :enclosures
    include Xml::Parseable
    
    element :id
    element :updated, :class => Time, :content_only => true
    element :title, :subtitle, :class => Content
    elements :authors, :contributors, :class => Person
    elements :links
    
    def initialize(o = {})
      @authors, @contributors, @links = [], [], Links.new

      case o
      when XML::Reader
        unless current_node_is?(o, 'source', NAMESPACE)
          raise ArgumentError, "Invalid node for atom:source - #{o.name}(#{o.namespace})"
        end

        o.read
        parse(o)
      when Hash
        o.each do |k, v|
          self.send("#{k.to_s}=", v)
        end
      else
        raise ArgumentError, "Got #{o.class} but expected a Hash or XML::Reader"
      end
      
      yield(self) if block_given?   
    end
  end
 
  # Offer easily access to Atom link relationships, such as <tt>post.next</tt> for 
  # <tt>&lt;link rel="next" href="http://resource.entrypoint.com/post/12" type="application/atom+xml" /&gt;</tt> relationships.
  module LinkShortcut

    def method_missing(method_sym,*args)#:nodoc:
      selected_links = links.select{ |l| l.rel == method_sym.to_s }
      super if selected_links.empty?
      selected_links.size == 1 ? selected_links.first : selected_links
    end

    def respond_to?(symbol)
      respond_to_rel?(symbol.to_s) || super(symbol)
    end
    
    private
    # whether this response contains specific relations
    def respond_to_rel?(rel)
      links.any? { |link| link.rel==rel }
    end

  end

  module HashConverter
    def to_hash
      Hash.from_xml(to_xml).with_indifferent_access
    end
  end

  # Represents a Feed as defined by the Atom Syndication Format specification.
  #
  # A feed is the top level element in an atom document.  It is a container for feed level
  # metadata and for each entry in the feed.
  #
  # This supports pagination as defined in RFC 5005, see http://www.ietf.org/rfc/rfc5005.txt
  # 
  # == Parsing
  #
  # A feed can be parsed using the Feed.load_feed method. This method accepts a String containing
  # a valid atom document, an IO object, or an URI to a valid atom document. For example:
  #
  #   # Using a File
  #   feed = Feed.load_feed(File.open("/path/to/myfeed.atom"))
  #
  #   # Using a URL
  #   feed = Feed.load_feed(URI.parse("http://example.org/afeed.atom"))
  # 
  # == Encoding
  #
  # A feed can be converted to XML using, the to_xml method that returns a valid atom document in a String.
  #
  # == Attributes
  #
  # A feed has the following attributes:
  #
  # +id+:: A unique id for the feed.
  # +updated+:: The Time the feed was updated.
  # +title+:: The title of the feed.
  # +subtitle+:: The subtitle of the feed.
  # +authors+:: An array of Atom::Person objects that are authors of this feed.
  # +contributors+:: An array of Atom::Person objects that are contributors to this feed.
  # +generator+:: A Atom::Generator.
  # +categories+:: A list of Atom:Category objects for the feed.
  # +rights+:: A string describing the rights associated with this feed.
  # +entries+:: An array of Atom::Entry objects.
  # +links+:: An array of Atom:Link objects. (This is actually an Atom::Links array which is an Array with some sugar).
  #
  # == References
  # See also http://www.atomenabled.org/developers/syndication/atom-format-spec.php#element.feed
  #
  class Feed
    include Xml::Parseable
    include SimpleExtensions
    include LinkShortcut
    include HashConverter
    extend Forwardable
    def_delegators :@links, :alternate, :self, :via, :first_page, :last_page, :next_page, :prev_page

    loadable! 
    
    namespace Atom::NAMESPACE
    element :id, :rights
    element :generator, :class => Generator
    element :title, :subtitle, :class => Content
    element :updated, :class => Time, :content_only => true
    elements :links
    elements :authors, :contributors, :class => Person
    elements :categories
    elements :entries
    
    # Initialize a Feed.
    #
    # This will also yield itself, so a feed can be constructed like this:
    #
    #   feed = Feed.new do |feed|
    #     feed.title = "My Cool feed"
    #   end
    # 
    # +o+:: An XML Reader or a Hash of attributes.
    #
    def initialize(o = {})
      @links, @entries, @authors, @contributors, @categories = Links.new, [], [], [], []
      
      case o
      when XML::Reader
        if next_node_is?(o, 'feed', Atom::NAMESPACE)
          o.read
          parse(o)
        else
          raise ArgumentError, "XML document was missing atom:feed: #{o.read_outer_xml}"
        end
      when Hash
        o.each do |k, v|
          self.send("#{k.to_s}=", v)
        end
      else
        raise ArgumentError, "Got #{o.class} but expected a Hash or XML::Reader"
      end
      
      yield(self) if block_given?
    end
    
    # Return true if this is the first feed in a paginated set.
    def first?
      links.self == links.first_page
    end 
    
    # Returns true if this is the last feed in a paginated set.
    def last?
      links.self == links.last_page
    end
    
    # Reloads the feed by fetching the self uri.
    def reload!(opts = {})
      if links.self
        Feed.load_feed(URI.parse(links.self.href), opts)
      end
    end
    
    # Iterates over each entry in the feed.
    #
    # ==== Options
    #
    # +paginate+::  If true and the feed supports pagination this will fetch each page of the feed.
    # +since+::     If a Time object is provided each_entry will iterate over all entries that were updated since that time.
    # +user+::      User name for HTTP Basic Authentication.
    # +pass+::      Password for HTTP Basic Authentication.
    #
    def each_entry(options = {}, &block)
      if options[:paginate]
        since_reached = false
        feed = self
        loop do          
          feed.entries.each do |entry|
            if options[:since] && entry.updated && options[:since] > entry.updated
              since_reached = true
              break
            else
              block.call(entry)
            end
          end
          
          if since_reached || feed.next_page.nil?
            break
          else feed.next_page
            feed = feed.next_page.fetch(options)
          end
        end
      else
        self.entries.each(&block)
      end
    end   


  end
  
  # Represents an Entry as defined by the Atom Syndication Format specification.
  #
  # An Entry represents an individual entry within a Feed.
  #
  # == Parsing
  #
  # An Entry can be parsed using the Entry.load_entry method. This method accepts a String containing
  # a valid atom entry document, an IO object, or an URI to a valid atom entry document. For example:
  #
  #   # Using a File
  #   entry = Entry.load_entry(File.open("/path/to/myfeedentry.atom"))
  #
  #   # Using a URL
  #   Entry = Entry.load_entry(URI.parse("http://example.org/afeedentry.atom"))
  # 
  # The document must contain a stand alone entry element as described in the Atom Syndication Format.
  # 
  # == Encoding
  #
  # A Entry can be converted to XML using, the to_xml method that returns a valid atom entry document in a String.
  #
  # == Attributes
  #
  # An entry has the following attributes:
  #
  # +id+:: A unique id for the entry.
  # +updated+:: The Time the entry was updated.
  # +published+:: The Time the entry was published.
  # +title+:: The title of the entry.
  # +summary+:: A short textual summary of the item.
  # +authors+:: An array of Atom::Person objects that are authors of this entry.
  # +contributors+:: An array of Atom::Person objects that are contributors to this entry.
  # +rights+:: A string describing the rights associated with this entry.
  # +links+:: An array of Atom:Link objects. (This is actually an Atom::Links array which is an Array with some sugar).
  # +source+:: Metadata of a feed that was the source of this item, for feed aggregators, etc.
  # +categories+:: Array of Atom::Categories.
  # +content+:: The content of the entry. This will be one of Atom::Content::Text, Atom::Content:Html or Atom::Content::Xhtml.
  #
  # == References
  # See also http://www.atomenabled.org/developers/syndication/atom-format-spec.php#element.entry for more detailed
  # definitions of the attributes.
  #
  class Entry
    include Xml::Parseable
    include SimpleExtensions
    include LinkShortcut
    include HashConverter
    extend Forwardable
    def_delegators :@links, :alternate, :self, :alternates, :enclosures, :edit_link, :via
    
    loadable!
    namespace Atom::NAMESPACE
    element :title, :id, :summary
    element :updated, :published, :class => Time, :content_only => true
    element :source, :class => Source
    elements :links
    elements :authors, :contributors, :class => Person
    elements :categories, :class => Category
    element :content, :class => Content
        
    # Initialize an Entry.
    #
    # This will also yield itself, so an Entry can be constructed like this:
    #
    #   entry = Entry.new do |entry|
    #     entry.title = "My Cool entry"
    #   end
    # 
    # +o+:: An XML Reader or a Hash of attributes.
    #
    def initialize(o = {})
      @links = Links.new
      @authors = []
      @contributors = []
      @categories = []
      
      case o
      when XML::Reader
        if current_node_is?(o, 'entry', Atom::NAMESPACE) || next_node_is?(o, 'entry', Atom::NAMESPACE)
          o.read
          parse(o)
        else
          raise ArgumentError, "Entry created with node other than atom:entry: #{o.name}"
        end
      when Hash
        o.each do |k,v|
          send("#{k.to_s}=", v)
        end
      else
        raise ArgumentError, "Got #{o.class} but expected a Hash or XML::Reader"
      end

      yield(self) if block_given?
    end   
    
    # Reload the Entry by fetching the self link.
    def reload!(opts = {})
      if links.self
        Entry.load_entry(URI.parse(links.self.href), opts)
      end
    end

  end

  # Links provides an Array of Link objects belonging to either a Feed or an Entry.
  #
  # Some additional methods to get specific types of links are provided.
  #
  # == References
  # 
  # See also http://www.atomenabled.org/developers/syndication/atom-format-spec.php#element.link
  # for details on link selection and link attributes.
  #
  class Links < DelegateClass(Array)
    include Enumerable
    
    # Initialize an empty Links array.
    def initialize
      super([])
    end
    
    # Get the alternate.
    #
    # Returns the first link with rel == 'alternate' that matches the given type.
    def alternate(type = nil)
      detect { |link| 
        (link.rel.nil? || link.rel == Link::Rel::ALTERNATE) && (type.nil? || type == link.type) && (link.hreflang.nil?) 
      } || detect { |link| 
        (link.rel.nil? || link.rel == Link::Rel::ALTERNATE) && (type.nil? || type == link.type) 
      }
    end
    
    # Get all alternates.
    def alternates
      select { |link| link.rel.nil? || link.rel == Link::Rel::ALTERNATE }
    end
    
    # Gets the self link.
    def self
      detect { |link| link.rel == Link::Rel::SELF }
    end
    
    # Gets the via link.
    def via
      detect { |link| link.rel == Link::Rel::VIA }
    end
    
    # Gets all links with rel == 'enclosure'
    def enclosures
      select { |link| link.rel == Link::Rel::ENCLOSURE }
    end
    
    # Gets the link with rel == 'first'.
    #
    # This is defined as the first page in a pagination set.
    def first_page
      detect { |link| link.rel == Link::Rel::FIRST }
    end
    
    # Gets the link with rel == 'last'.
    #
    # This is defined as the last page in a pagination set.
    def last_page
      detect { |link| link.rel == Link::Rel::LAST }
    end
    
    # Gets the link with rel == 'next'.
    #
    # This is defined as the next page in a pagination set.
    def next_page
      detect { |link| link.rel == Link::Rel::NEXT }
    end
    
    # Gets the link with rel == 'prev'.
    #
    # This is defined as the previous page in a pagination set.
    def prev_page
      detect { |link| link.rel == Link::Rel::PREVIOUS }
    end
    
    # Gets the edit link.
    #
    # This is the link which can be used for posting updates to an item using the Atom Publishing Protocol.
    #
    def edit_link
      detect { |link| link.rel == 'edit' }
    end
  end
  
  # Represents a link in an Atom document.
  #
  # A link defines a reference from an Atom document to a web resource.
  #
  # == References
  # See http://www.atomenabled.org/developers/syndication/atom-format-spec.php#element.link for
  # a description of the different types of links.
  #
  class Link
    module Rel # :nodoc:
      ALTERNATE = 'alternate'
      SELF = 'self'
      VIA = 'via'
      ENCLOSURE = 'enclosure'
      FIRST = 'first'
      LAST = 'last'
      PREVIOUS = 'prev'
      NEXT = 'next'
    end    
    
    include Xml::Parseable
    attribute :href, :rel, :type, :length, :hreflang, :title
        
    # Create a link.
    #
    # +o+:: An XML::Reader containing a link element or a Hash of attributes.
    #
    def initialize(o)
      case o
      when XML::Reader
        if current_node_is?(o, 'link')
          parse(o, :once => true)
        else
          raise ArgumentError, "Link created with node other than atom:link: #{o.name}"
        end
      when Hash
        [:href, :rel, :type, :length, :hreflang, :title].each do |attr|
          self.send("#{attr}=", o[attr])
        end
      else
        raise ArgumentError, "Don't know how to handle #{o}"
      end        
    end
    
    remove_method :length=
    def length=(v)
      @length = v.to_i
    end
    
    def to_s
      self.href
    end
    
    def ==(o)
      [:href, :rel, :type].all? { |k| o.respond_to?(k) && o.send(k) == self.send(k) }
    end
    
    # This will fetch the URL referenced by the link.
    #
    # If the URL contains a valid feed, a Feed will be returned, otherwise,
    # the body of the response will be returned.
    #
    # TODO: Handle redirects.
    #
    def fetch(options = {})
      begin
        Atom::Feed.load_feed(URI.parse(self.href), options)
      rescue ArgumentError
        Net::HTTP.get_response(URI.parse(self.href)).body
      end
    end
    
    def inspect
      "<Atom::Link rel:'#{rel}' href:'#{href}' type:'#{type}'>"
    end
  end
end
