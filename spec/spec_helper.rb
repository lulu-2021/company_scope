$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
#
require 'rspec'
require 'rspec/given'
require 'rails/all'
require 'rspec/rails'
require 'rspec/collection_matchers'
require 'request_store'
require 'active_record_helper'
#
require 'company_scope'
#
RSpec.configure do |config|
  config.after(:each) do
    # do stuff here if needed
  end

  #config.infer_base_class_for_anonymous_controllers = true
end

# Setup a test app
module TestApp
  class Application < Rails::Application; end
end

TestApp::Application.config.secret_token = '1234567890123456789012345678901234567890'
TestApp::Application.config.secret_key_base = '1234567890123456789012345678901234567890'
