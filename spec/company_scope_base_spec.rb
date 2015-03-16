require 'spec_helper'
require 'active_record_models'
require 'company_scope/control'
#
describe CompanyScope::Base do
  #
  Given!(:company1) { Company.create(company_name: 'DEFAULT') }
  Given!(:company2) { Company.create(company_name: 'SECOND') }
  Given!(:setup) { Company.current_id = company1.id }
  #
  Given(:user) { User.create(user_name: 'joe_blogs') }
  Given(:task1) { Task.create(name: 'Task1', user: user, completed: false) }
  Given(:task2) { Task.create(name: 'Task2', user: user, completed: false) }
  Given(:task3) { Task.create(name: 'Task3', user: user, completed: false) }
  #
  context 'checking whether the correct methods have been injected' do
    Then { expect(User).to respond_to(:belongs_to) }
    Then { expect(user).to respond_to(:company) }
  end

  context 'the default scope should be set on the user' do
    Then { expect(user.company.company_name).to eq 'DEFAULT' }
  end

  context 'the default scope should be set on the task' do
    Then { expect(task1.company.company_name).to eq 'DEFAULT' }
    Then { expect(task2.company.company_name).to eq 'DEFAULT' }
    Then { expect(task3.company.company_name).to eq 'DEFAULT' }
  end

  context 'attempting to create a user without a company' do
    When { user.company = nil; user.save }
    Then { expect(user).to have(1).errors_on(:company_id) }
  end

  context 'attempting to create a task without a company' do
    When { task1.company = nil; task1.save }
    Then { expect(task1).to have(1).errors_on(:company_id) }
  end

  context 'attempting to create a user when the company has not been set' do
    Given { Company.current_id = nil }
    Given(:test_user) { User.new(user_name: 'jack_black') }
    When { test_user.save }
    Then { expect(test_user).to have(1).errors_on(:company_id) }
  end

  context 'should raise an Error during an attempt to set the company to the wrong value' do
    Given(:company_id) { 2 }
    Given(:wrong_company_id) { 999 }
    Given { Company.current_id = company_id }
    Given!(:test_user) { User.create(user_name: 'wrong_user_test') }
    When { Company.current_id = wrong_company_id } # i.e. something out of the range..

    Then {
      expect(lambda { test_user.save }).to raise_error('CompanyScope::Control::CompanyAccessViolationError')
      expect(test_user.company_id).to eq company_id
    }
  end
end
