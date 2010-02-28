class Item < ActiveRecord::Base
  belongs_to :order
  
  acts_as_restfulie do |item, t|
    # t << [:self, {:action => :show}]
  end
  
  def to_xml(options = {})
    options[:except] ||= []
    options[:except] << :order_id
    super(options)
  end
  
end
