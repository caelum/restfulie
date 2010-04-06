class Restfulie::Common::Builder::Rules::Links < Array
  alias_method :old_delete, :delete

  def delete(item)
    item = item.to_s if item.kind_of?(Symbol) 
    deleted = old_delete(item)
    deleted.nil? ? old_delete(find { |i| i.rel == item }) : deleted
  end
end