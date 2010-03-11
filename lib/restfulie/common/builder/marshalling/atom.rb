class Restfulie::Builder::Marshalling::Atom < Restfulie::Builder::Marshalling::Base
  include ActionController::UrlWriter
  include Restfulie::Builder::Helpers
  
  def initialize(member, rule)
    @member = member
    @rule   = rule
  end
  
  def to_xml(options = {})
    options = {
      :default_rule => true
    }.merge(options)

    @rule.blocks.unshift(default_member_rule) if options[:default_rule]
    @rule.apply(@member)
    
    entry_atom = ::Atom::Entry.new do |entry|
      entry.id     = @rule.id
      entry.title  = @rule.title
      entry.published = @rule.published
      entry.updated   = @rule.updated
      
      @rule.links.each do |link|
        href = link.href || polymorphic_url(@member, :host => 'localhost')
        entry.links << ::Atom::Link.new(:rel => link.rel, :href => href, :type => link.type)
      end
    end

    entry_atom.to_xml
  end
  
  def default_member_rule
    @default_member_rule ||= lambda do |member, object|
      member.id        = polymorphic_url(@member, :host => 'localhost')
      member.title     = object.respond_to?(:title) && !object.title.nil? ? object.title : "Entry about #{object.class.to_s.demodulize}"
      member.published = object.created_at
      member.updated   = object.updated_at

      member.links << link(:rel => :self, :type => 'application/atom+xml')
    end
  end
  
  class << self
    def builder_member(member, rule, options = {})
      self.new(member, rule).to_xml(options)
    end
  end

end