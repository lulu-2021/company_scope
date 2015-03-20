$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
#
require 'rspec'
require 'rspec/given'
require 'rack'
require 'rails/all'
require 'rspec/rails'
require 'rspec/collection_matchers'
require 'request_store'
require 'active_record_helper'
#
require 'company_scope'
#
# Setup a test app
#
require 'rack/multi_company'
#
module TestApp
  #
  class Application < Rails::Application
    #
    config.middleware.insert_after Rack::Sendfile, Rack::MultiCompany, :my_company
    #
  end
end
#
TestApp::Application.config.secret_token = '1234567890123456789012345678901234567890'
TestApp::Application.config.secret_key_base = '1234567890123456789012345678901234567890'
