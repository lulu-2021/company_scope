#
require 'spec_helper'
#
# This dummy class is needed since the during the application load the class does not
# yet exist.. it will be overwritten by the version in active_record_models
#
class MyCompany < ActiveRecord::Base; end
#
require 'spec_helper_load_application'
#
require 'active_record_models'
require 'active_record_schema'
#
class DummyApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers
  company_setup # - inject the setup
end
#
describe DummyApplicationController, type: :controller do
  # this is an anonymous controller to test without needing to configure a route!
  controller (DummyApplicationController) do
    acts_as_company_filter # load the around filter

    def index # - the response gives us the id that was injected by the company_scope gem!
      render json: {
        my_company_id: "#{MyCompany.current_id}",
      }, status: 200
    end
  end
  #
  context 'checking whether the correct methods have been injected' do
    Given!(:default_company_name) { 'DEFAULT' }
    Given!(:test_company) {
      company = MyCompany.create(company_name: default_company_name )
      # - since the rack middleware is not being tested here - we need to set this!
      request.env["COMPANY_ID"] = company.id
      company
    }
    #
    When { get :index }
    #
    Then { expect(response.status).to eq 200 }
    Then { expect(JSON.parse(response.body)['my_company_id']).to eq test_company.id.to_s }
    #
    Then { expect(controller).to respond_to(:company_scope_company_not_set) }
  end
end
