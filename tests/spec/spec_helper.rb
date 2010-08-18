# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

module ResponseMatchers

  class ResponseStatus

    def initialize(response_code)
      @expected_code = response_code.to_i
    end

    def matches?(response_header)
      @actual_code = response_header[2].code
      @expected_code == @actual_code
    end

    def failure_message
        "expected response status to be #{@expected_code} but it's #{@actual_code}"
    end

    def negative_failure_message
        "didn't expect #{@expected_code} to be #{@actual_code}"
    end

  end

  def respond_with_status(response_code)
    ResponseStatus.new(response_code)
  end

end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include(ResponseMatchers)
end
