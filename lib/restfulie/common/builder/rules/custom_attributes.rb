# Rules that allow any type of content shall extend this one and provide valid serialization methods. i.e.: to_xml
module Restfulie::Common::Builder::Rules::CustomAttributes

  # returns true if it's a valid attribute evaluation or 
  def method_missing(sym, *args)
    if sym.to_s.last=="=" && args.size==1
      custom_attributes[sym.to_s.chop] = args[0]
    elsif custom_attributes[sym.to_s]
      custom_attributes[sym.to_s]
    else
      super(sym, *args)
    end
  end
  
  def respond_to?(sym)
    super(sym) || (sym.to_s.last == "=") || custom_attributes[sym.to_s]
  end
  
  private 
  
  def custom_attributes
    @custom_attributes ||= {}
  end
end
