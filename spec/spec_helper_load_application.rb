#
# Setup a test app
require 'company_scope'
#
module TestApp
  #
  class Application < ::Rails::Application
    #
    # This is the only configuration requirement for the company_scope gem
    # i.e. set the scoping model during the Rails startup configuration
    #
    config.company_scope.company_model = :my_company
    config.company_scope.company_name_matcher = :subdomain_matcher
    #
  end
end
#
TestApp::Application.config.secret_token = '1234567890123456789012345678901234567890'
TestApp::Application.config.secret_key_base = '1234567890123456789012345678901234567890'
#
TestApp::Application.initialize!
#
