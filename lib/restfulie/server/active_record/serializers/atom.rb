# Serializes an ActiveRecord model to an Atom representation.
# 
# It uses Ratom to generate the Atom XML, and it depends on Rails routes
# to generate the href of Atom links.
#
# So, to generate the atom self link for a model named Song, we use the 
# named route songs_url, passing the model as an argument.
#
# Similarly, if Songs belongs_to album, we use the named route 
# album_url(@song.album). So, we are using our routes to generate the
# necessary atom links.
#
# If the association is a has_many (Album has_many songs), we use the 
# named route album_songs_url to create the Atom::Link. We call it as 
#
#   album_songs_url([@album, :songs], :host => 'myhost.com')
#
# In order to have this named route, we can create it by hand, or using
# nested resources:
#
#   map.resources :albums do |album|
#     album.resources :songs, :controller => 'albums/songs'
#   end
#
# == Atom Extensions
#
# We need to extend the Atom to include the model's attribute, 
# keeping the XML valid.
#
# So, in an Atom XML for a model named Song, we register a namespace
# of "urn:song", and its attribute becomes <song:description>, <song:length>,
# and so on.
# 
# To do so, we register the namespace "urn:song" and each attribute.
#
class Restfulie::Server::ActiveRecord::Serializers::Atom
  include ::ActionController::UrlWriter
  ATTRIBUTES_ALREADY_IN_ATOM_SPEC = ["id", "title", "updated_at", "created_at"]

  attr_reader :record

  def initialize(record, options={}, &block)
    @record = record
    register_namespace(namespaced_class)
  end

  def atomify(options={})
  
    ::Atom::Entry.new do |entry|
      # TODO: this id does not comply with Rest standards yet
      entry.id        = @record.id
      entry.title     = "Entry about #{@record.class}"
      entry.published = @record.created_at
      entry.updated   = @record.updated_at
    
      entry.links     << atom_self_link unless options[:skip_self_link]
      entry.links     += atom_associations_links if atom_associations && !options[:skip_associations_links]
    
      # TODO: Deal with authors
      # TODO: Deal with content and summary

      extension_attributes.each do |attribute|
        register_element(attribute)
        entry.send("#{namespaced_class}_#{attribute}=", @record.send(attribute))
      end unless options[:skip_attributes]
    
      yield entry if block_given?
    end
  end

protected

  def atom_self_link(options={})
    ::Atom::Link.new(:rel => :self, :href => route_generator(@record))
  end

  def atom_associations_links(options={})
    # TODO: Maybe use namespaced routes for polymorphic_url. 
    # TODO: Create default options to be passed to polymorphic_url.
    
    atom_associations.map do |association|
      if [:has_many, :has_and_belongs_to_many].include? association.macro
        ::Atom::Link.new(:rel => association.name, :href => route_generator([@record, association.name]))
      else
        ::Atom::Link.new(:rel => association.name, :href => route_generator(@record.send(association.name)))
      end
    end
  end

  def atom_associations
    @record.class.reflect_on_all_associations
  end

  def extension_attributes
    @record.class.column_names - ATTRIBUTES_ALREADY_IN_ATOM_SPEC
  end

  def register_element(attribute)
    ::Atom::Entry.element(namespaced_class_and_attribute(attribute)) if element_unregistered?(namespaced_class_and_attribute(attribute))
  end

  def register_elements(attribute)
    ::Atom::Entry.elements(namespaced_class_and_attribute(attribute)) if element_unregistered?(namespaced_class_and_attribute(attribute))
  end

  def element_unregistered?(element)
    ::Atom::Entry.element_specs.select { |k,v|  v.name == element }.empty?
  end

  def namespaced_class_and_attribute(attribute)
    "#{namespaced_class}:#{attribute}"
  end

  def namespaced_class
    @record.class.name.downcase.gsub(/_/, ':')
  end

  def register_namespace(namespace)
    ::Atom::Entry.add_extension_namespace(namespace, urn(namespace)) unless ::Atom::Entry.known_namespaces.include? urn(namespace)
  end

  def urn(name)
    "urn:#{name}"
  end
  
  def route_generator(record_or_array)
    host               = ::Restfulie::Server::Configuration.host
    named_route_prefix = ::Restfulie::Server::Configuration.named_route_prefix
    
    array_of_segments = Array(record_or_array)
    array_of_segments.unshift(named_route_prefix).compact!
    
    polymorphic_url(array_of_segments, :host => host)
  end
end

