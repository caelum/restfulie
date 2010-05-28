module Restfulie::Common::Converter::Json::Helpers
  def collection(obj, *args, &block)
    Restfulie::Common::Converter::Json.to_json(obj, &block)
  end

  def member(obj, *args, &block)
    Restfulie::Common::Converter::Json.to_json(obj, &block)
  end
end