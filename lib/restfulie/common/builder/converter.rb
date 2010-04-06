module Restfulie::Common::Builder::Marshalling
  class << self
    def add_autoload_path(path)
      if File.directory?(path)
        Dir["#{path}/*.rb"].each do |file|
          marshalling_class = File.basename(file, ".rb").downcase.classify.to_sym
          self.autoload(marshalling_class, file) if !self.const_defined?(marshalling_class) && self.autoload?(marshalling_class).nil?
        end
      else
        raise Restfulie::Common::Error::MarshallingError.new("#{path} is not a path.")
      end
    end
  end

  self.add_autoload_path(File.join(File.dirname(__FILE__), 'converter'))
end
