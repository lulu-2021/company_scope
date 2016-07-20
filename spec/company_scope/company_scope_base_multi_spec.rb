#
require 'spec_helper'
require 'spec_helper_without_railtie'
#
require 'active_record_schema'
require 'active_record_models'
#
describe CompanyScope::Base do
  #
  Given!(:user_name1) { 'joe_blogsie' }
  Given!(:user_name2) { 'jack_black' }
  Given!(:task_name1) { 'Task1' }
  Given(:lead_1_first_name) { 'joe' }
  Given(:lead_2_first_name) { 'jane' }
  Given(:lead_last_name) { 'blogs' }
  #
  Given!(:setup1) {
    my_company1 = MyCompany.create(company_name: 'DEFAULT')
    MyCompany.current_id = my_company1.id
    user1 = User.create!(user_name: user_name1)
    Task.create!(name: task_name1, user: user1, completed: false)
    Task.create!(name: 'Task2', user: user1, completed: false)
    Lead.create(first_name: lead_1_first_name, last_name: lead_last_name)
    Lead.create(first_name: lead_2_first_name, last_name: lead_last_name)
    my_company1.id
  }
  Given!(:setup2) {
    my_company2 = MyCompany.create(company_name: 'SECOND')
    MyCompany.current_id = my_company2.id
    user2 = User.create!(user_name: user_name2)
    Task.create!(name: 'Task1', user: user2, completed: false)
    Task.create!(name: 'Task2', user: user2, completed: false)
    Lead.create(first_name: lead_1_first_name, last_name: lead_last_name)
    Lead.create(first_name: lead_2_first_name, last_name: lead_last_name)
    my_company2.id
  }

  context 'lead 1 should have the right company' do
    Given!(:retrieve_lead) {
      MyCompany.current_id = setup1
      MyCompanyView.current_ids = [MyCompany.current_id]
      Lead.where(first_name: lead_1_first_name).first
    }

    Then { expect(retrieve_lead.my_company.company_name).to eq 'DEFAULT' }
  end
  #
end
