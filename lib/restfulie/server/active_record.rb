if defined?(::ActiveRecord) && defined?(::ActionController)
  module Restfulie::Server::ActiveRecord #:nodoc:
  end
  %w(
    serializers
    base
  ).each do |file|
    require "restfulie/server/active_record/#{file}"
  end
end
