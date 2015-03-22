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
describe CompanyScope::Guardian do

  Given!(:default_company_name) { 'DEFAULT' }

  Given!(:setup) {
    company = MyCompany.create(company_name: default_company_name )
    MyCompany.current_id = company.id
    company.id
  }

  context 'checking whether the correct methods have been injected' do
    Given(:retrieve_company) { MyCompany.where(company_name: default_company_name).first }

    Then { expect(retrieve_company.class).to respond_to(:acts_as_guardian) }
    Then { expect(retrieve_company.class.current_id).to eq MyCompany.current_id }
  end
end
