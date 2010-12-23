class Restfulie::Common::Converter::FormUrlEncoded < Tokamak::Representation::Generic
  def self.marshal(content, rel)
      if content.kind_of? Hash
        content.map { |key, value| "#{key}=#{value}" }.join("&")
      else
        content
      end
  end
  
  def self.unmarshal(content)
  	def content.links
      []
    end
    content
  end
end