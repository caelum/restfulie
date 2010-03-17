class Order < ActiveRecord::Base
  
  acts_as_restfulie do |order, t|
    t << [:self, {:action => :show}]
    t << [:retrieve, {:id => order, :action => :destroy}] if order.is_ready?
    t << [:receipt, {:order_id => order, :controller => :payments, :action => :receipt}] if order.status=="delivered"
    if order.status=="unpaid"
      t << [:cancel, {:action => :destroy}]
      t << [:payment, {:action => :create, :controller => :payments, :order_id => order.id}]
      t << [:update]
    end
    # def t.relates_to(what)
      what = :items
      t << [what.to_s, {:action => :index, :controller => what, :order_id => order.id}]
    # end
    # t.relates_to :items
  end
  
  media_type 'application/vnd.restbucks+xml'
  has_many :items
  has_one :payment
  
  def initialize(hash = {})
    super(hash)
    self.status = "unpaid" unless self.status
  end
  
  def status
    (super=="preparing") && (payment.created_at < (Time.now - 15.seconds)) ? "ready" : super
  end
  
  def to_xml(options = {})
    options[:include] = [:items, :payment]
    options[:methods] = [:cost]
    super(options)
  end
  
  def cost
    items.size * 10
  end
  
  def is_ready?
    status == "ready"
  end
  
  def etag
    [self, payment]
  end
  
end
