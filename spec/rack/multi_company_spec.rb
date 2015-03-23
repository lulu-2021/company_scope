require 'spec_helper'
require 'company_scope'
#
require File.dirname(__FILE__) + '/mock_rack_app'
require File.dirname(__FILE__) + '/mock_company'
require File.dirname(__FILE__) + '/mock_matcher'
#
describe Custom::MultiCompany do
  Given{ Rails.env = 'test' }

  Given!(:test_app) { MockRackApp.new }
  Given!(:mock_matcher) { MockMatcher }
  Given!(:rack_test_middleware) { Custom::MultiCompany.new(test_app, :mock_company, :mock_matcher) }
  Given!(:rack_mock_request) { Rack::MockRequest.new(rack_test_middleware) }

  context 'checking initialisation MultiCompany rack middleware' do
    Then { expect(rack_test_middleware.company_class_name).to eq 'MockCompany' }
  end

  context 'checking that the COMPANY_ID value is correctly set in the call method' do
    When { rack_mock_request.get('/', {"HTTP_HOST" => "default.lvh.me"}) }

    Then { expect(test_app["COMPANY_ID"]).to eq 'DEFAULT_ID' }
  end

  context 'raise Error when company in subdomain is not found' do
    #Then {
    #  expect(lambda { rack_mock_request.get('/', {"HTTP_HOST" => "badtenant.lvh.me"}) }).to raise_error('CompanyScope::Control::CompanyAccessViolationError')
    #}
  end
end
