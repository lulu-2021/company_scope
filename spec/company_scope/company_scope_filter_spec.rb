require 'spec_helper'
require 'company_scope'
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
        company_id: "#{Company.current_id}",
      }, status: 200
    end
  end

  context 'checking whether the correct methods have been injected' do
    #
    Given!(:default_company_name) { 'DEFAULT' }
    Given!(:test_company) {
      company = Company.create(company_name: default_company_name )
      request.env["COMPANY_ID"] = company
      company
    }
    #
    When { get :index }
    #
    Then { expect(response.status).to eq 200 }
    Then { expect(JSON.parse(response.body)['company_id']).to eq test_company.id.to_s }
  end
end
