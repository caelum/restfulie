module DataHelper
  
  def response_data(format, filename)
    filename = File.join(File.dirname(__FILE__), format.to_s, filename)
    raise "File not found: #{filename}. Check atoms spec folder for available samples." if !File.exist?(filename)
    file_dump = ""
    File.open(filename, "r") do |file|
      file.each_line {|line| file_dump << line }
    end
    return file_dump
  end
  
end
include DataHelper

