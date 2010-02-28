class Payment < ActiveRecord::Base
  
  acts_as_restfulie
  
  media_type 'application/vnd.restbucks+xml'
  
  belongs_to :order
  
  def initialize(hash = {})
    super(hash)
  end

  def to_xml(options = {})
    options[:except] ||= []
    options[:except] << :order_id
    super(options)
  end
  
end
