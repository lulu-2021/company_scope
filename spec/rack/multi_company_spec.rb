require 'spec_helper'
require 'company_scope'
#
require File.dirname(__FILE__) + '/mock_rack_app'
require File.dirname(__FILE__) + '/my_company'
#
describe Rack::MultiCompany do
  Given{ Rails.env = 'test' }

  Given!(:test_app) { MockRackApp.new }
  Given!(:rack_test_middleware) { Rack::MultiCompany.new(test_app, :my_company) }
  Given!(:rack_mock_request) { Rack::MockRequest.new(rack_test_middleware) }

  context 'checking initialisation MultiCompany rack middleware' do
    Then { expect(rack_test_middleware.company_class_name).to eq 'MyCompany' }
  end

  context 'checking that the COMPANY_ID value is correctly set in the call method' do
    When { rack_mock_request.get('/', {"HTTP_HOST" => "default.lvh.me"}) }

    Then { expect(test_app["COMPANY_ID"].company_name).to eq 'DEFAULT' }
  end
end
