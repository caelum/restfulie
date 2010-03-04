class Restfulie::Builder::Rules
  class Links < Array
    alias_method :old_delete, :delete
      
    def delete(item)
      item = item.to_s if item.kind_of?(Symbol) 
      deleted = old_delete(item)
      deleted.nil? ? old_delete(find { |i| i.rel == item }) : deleted
    end
  end
  
  class Link
    attr_accessor :rel
    attr_accessor :href
    
    # TODO: Inline entrys support
    def initialize(options = {})
      options = { :rel => options } unless options.kind_of?(Hash)
      options.each do |k, i|
        self.send("#{k}=".to_sym, i)
      end
    end
    
    def rel=(value)
      @rel = value.kind_of?(String) ? value : value.to_s
    end
  end
end