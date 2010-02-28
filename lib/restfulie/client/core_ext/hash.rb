class Hash
  def to_object(body)
    if keys.length>1
      raise "unable to parse an xml with more than one root element"
    elsif keys.length == 0
      self
    else
      type = keys[0].camelize.constantize
      type.from_xml(body)
    end
  end
end