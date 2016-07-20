#
require 'spec_helper'
#
# This dummy class is needed since the during the application load the class does not
# yet exist.. it will be overwritten by the version in active_record_models
#
class Lead < ActiveRecord::Base; end
class MyCompany < ActiveRecord::Base; end
class MyCompanyView < ActiveRecord::Base; end
#
require 'spec_helper_load_application'
#
require 'active_record_models'
require 'active_record_schema'
#
describe CompanyScope::MultiGuardian do

  Given!(:first_company_name) { 'COMPANY_1' }
  Given!(:second_company_name) { 'COMPANY_2' }
  Given(:lead_1) { Lead.create(first_name: 'Jo', last_name: 'Blogs') }
  Given(:lead_2) { Lead.create(first_name: 'Jane', last_name: 'Blogs') }
  Given(:company_1) { MyCompany.create(company_name: first_company_name ) }
  Given(:company_2) { MyCompany.create(company_name: second_company_name ) }
  Given(:company_view_1) { MyCompanyView.create(my_company: company_1, lead: lead_1) }
  Given(:company_view_2) { MyCompanyView.create(my_company: company_2, lead: lead_2) }
  Given!(:company_view_ids) { [company_view_1.id, company_view_2.id] }

  context 'checking whether the correct methods have been injected into the company_views' do
    Given(:first_company) {
      MyCompany.current_id = company_view_ids[0]
      MyCompany.where(company_name: first_company_name).first
    }
    Given(:second_company) {
      MyCompany.current_id = company_view_ids[1]
      MyCompany.where(company_name: second_company_name).first
    }

    Then { expect(first_company.class).to respond_to(:acts_as_multi_guardian) }
    Then { expect(second_company.class).to respond_to(:acts_as_multi_guardian) }
  end

  context 'check the correct current_ids for the first company_view class' do
    Given { MyCompanyView.current_ids = company_view_ids }

    Then { expect(company_view_1.class.current_ids).to eq company_view_ids }
    Then { expect(company_view_2.class.current_ids).to eq company_view_ids }
  end

  context 'check the correct current_ids for the second company_view class' do
    Given { MyCompanyView.current_ids = company_view_ids }

    Then { expect(company_view_2.class.current_ids).to eq company_view_ids }
    Then { expect(company_view_1.class.current_ids).to eq company_view_ids }
  end

  context 'correct company id for the first company' do
    Given(:first_company) {
      MyCompany.current_id = company_view_ids[0]
      MyCompany.where(company_name: first_company_name).first
    }

    Then { expect(first_company.class.current_id).to eq MyCompany.current_id }
  end

  context 'correct company id for the second company' do
    Given(:second_company) {
      MyCompany.current_id = company_view_ids[1]
      MyCompany.where(company_name: second_company_name).first
    }

    Then { expect(second_company.class.current_id).to eq MyCompany.current_id }
  end
end
