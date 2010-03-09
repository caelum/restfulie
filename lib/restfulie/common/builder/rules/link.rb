class Restfulie::Builder::Rules::Link
  # Requered
  attr_accessor :href

  # Optional
  attr_accessor :rel, :type
  attr_accessor :hreflang, :title, :length

  # TODO: Inline resource and collection support
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