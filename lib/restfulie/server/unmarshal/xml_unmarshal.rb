class Restfulie::Server::HTTP::XmlUnmarshaller
  
  # Unmarshalls an xml using ActiveRecord's constructor with hash
  def self.unmarshal(content)
    begin
      h = Hash.from_xml(content)
      name = h.keys[0]
      type = name.camelize.constantize
      self.new_instance_from(type, h.values[0])
    rescue NameError, REXML::ParseException
      raise Restfulie::Server::HTTP::BadRequest
    end
  end
  
  private
  
  # instantiates either an active record or common type
  def self.new_instance_from(type, hash)
    if defined?(::ActiveRecord::Reflection) && type.included_modules.include?(::ActiveRecord::Reflection)
      type.new(hash)
    else
      self.new_from_hash(type, hash)
    end
  end
  
  # instantiates a common type and fills it with values from a hash
  def self.new_from_hash(type, hash)
    result = type.new
    hash.each do |key, value|
      result.send("#{key}=".to_s, value)
    end
    result
  end
  
end

["xml", "application/xml", "text/xml"].each do |type|
  Restfulie::Server::HTTP::Unmarshal.register(type, Restfulie::Server::HTTP::XmlUnmarshaller)
end
