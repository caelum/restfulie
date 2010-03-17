module DataHelper
  
  def response_data(format, filename)
    filename = File.join(File.dirname(__FILE__), format.to_s, filename)
    raise "File not found: #{filename}. Check atoms spec folder for available samples." if !File.exist?(filename)
    IO.read(filename)
  end
  
  alias_method :load_data, :response_data

end

include DataHelper