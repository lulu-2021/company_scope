require 'spec_helper'
require 'active_record_models'
require 'company_scope/control'
require 'request_store'
#
describe CompanyScope::Base do
  #
  Given!(:user_name1) { 'joe_blogsie' }
  Given!(:task_name1) { 'Task1' }
  Given!(:setup1) {
    company1 = Company.create(company_name: 'DEFAULT')
    Company.current_id = company1.id
    user1 = User.create!(user_name: user_name1)
    Task.create!(name: task_name1, user: user1, completed: false)
    Task.create!(name: 'Task2', user: user1, completed: false)
    company1.id
  }
  #
  Given!(:user_name2) { 'jack_black' }
  Given!(:setup2) {
    company2 = Company.create(company_name: 'SECOND')
    Company.current_id = company2.id
    user2 = User.create!(user_name: user_name2)
    Task.create!(name: 'Task1', user: user2, completed: false)
    Task.create!(name: 'Task2', user: user2, completed: false)
    company2.id
  }
  #
  context 'checking whether the correct methods have been injected into the user' do
    Given!(:retrieve_user) {
      Company.current_id = setup1
      User.where(user_name: user_name1).first
    }

    Then { expect(retrieve_user.class).to respond_to(:belongs_to)}
    Then { expect(retrieve_user.class.reflect_on_association(:company).present?).to eq true }
    Then { expect(retrieve_user).to respond_to(:company) }
  end

  context 'checking whether the correct methods have been injected into the task' do
    Given!(:retrieve_task) {
      Company.current_id = setup1
      Task.where(name: task_name1).first
    }

    Then { expect(retrieve_task.class).to respond_to(:belongs_to)}
    Then { expect(retrieve_task.class.reflect_on_association(:company).present?).to eq true }
    Then { expect(retrieve_task).to respond_to(:company) }
  end

  context 'the default scope should be set on the first user' do
    Given!(:retrieve_user) {
      Company.current_id = setup1
      User.where(user_name: user_name1).first
    }
    Then { expect(retrieve_user.company.company_name).to eq 'DEFAULT' }
    Then { expect(retrieve_user.user_name).to eq user_name1 }
  end

  context 'the default scope should be set on the second user' do
    Given!(:retrieve_user) {
      Company.current_id = setup2
      User.where(user_name: user_name2).first
    }
    Then { expect(retrieve_user.company.company_name).to eq 'SECOND' }
    Then { expect(retrieve_user.user_name).to eq user_name2 }
  end

  context 'the default scope should be set on the first two tasks' do
    Given!(:retrieve_tasks) {
      Company.current_id = setup1
      user = User.where(user_name: user_name1).first
      Task.where(user: user).all
    }
    Then {
      retrieve_tasks.each do |task|
        expect(task.company.company_name).to eq 'DEFAULT'
        expect(task.user.user_name).to eq user_name1
      end
    }
  end

  context 'the default scope should be set on the second two tasks' do
    Given!(:retrieve_tasks) {
      Company.current_id = setup2
      user = User.where(user_name: user_name2).first
      Task.where(user: user).all
    }
    Then {
      retrieve_tasks.each do |task|
        expect(task.company.company_name).to eq 'SECOND'
        expect(task.user.user_name).to eq user_name2
      end
    }
  end

  context 'attempting to create a user without a company' do
    Given!(:test_user) { User.new }
    When { Company.current_id = nil; test_user.company = nil; test_user.save }

    Then { expect(test_user).to have(1).errors_on(:company_id) }
  end

  context 'attempting to create a task without a company' do
    Given!(:test_task) { Task.new(name: 'test_task') }
    When { Company.current_id = nil; test_task.company = nil; test_task.save }

    Then { expect(test_task).to have(1).errors_on(:company_id) }
  end

  context 'attempting to create a user when the company has not been set' do
    Given!(:test_user) { User.new(user_name: 'jack_black') }
    When { Company.current_id = nil;  test_user.save }

    Then { expect(test_user).to have(1).errors_on(:company_id) }
  end

  context 'attempting to create a task when the company has not been set' do
    Given!(:test_task) { Task.new(name: 'test_task') }
    When { Company.current_id = nil;  test_task.save }

    Then { expect(test_task).to have(1).errors_on(:company_id) }
  end

  context 'should raise an Error during an attempt to set the company to the wrong value' do
    Given(:invalid_id) { 99999 }
    Given!(:retrieve_user) {
      Company.current_id = setup1
      User.where(user_name: user_name1).first
    }

    Then {
      Company.current_id = invalid_id  # i.e. be sure its out of range!
      expect(lambda { retrieve_user.save }).to raise_error('CompanyScope::Control::CompanyAccessViolationError')
    }
  end

  context 'it should scope the querying of the data by the current_company' do
    Then { expect(Task.unscoped.all.count).to eq 4 }
    Then { expect(User.unscoped.all.count).to eq 2 }

    Then {
      Company.current_id = setup1
      expect(User.all.count).to eq 1
      expect(Task.all.count).to eq 2
    }

    Then {
      Company.current_id = setup2
      expect(User.all.count).to eq 1
      expect(Task.all.count).to eq 2
    }
  end

  context 'inspecting the data' do
    Then {
      #Company.all.each { |c| puts "Company: #{c.inspect}\n" }
      #User.all.each { |u| puts "User: #{u.inspect}\n" }
      #User.unscoped.all.each { |u| puts "User: #{u.inspect}\n" }
      #Task.unscoped.all.each { |t| puts "Task: #{t.inspect}\n" }
    }
  end
end
