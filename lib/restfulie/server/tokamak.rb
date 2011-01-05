if defined? ::ActionView and ::ActionController
  require 'tokamak/hook/rails'
  # TODO autoloading, should be optional
  Tokamak::Builder::Xml
  Tokamak::Builder::Json
end
