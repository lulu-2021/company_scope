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
  Given!(:task_name1) { 'Task1' }
  Given!(:setup1) {
    my_company1 = MyCompany.create(company_name: 'DEFAULT')
    MyCompany.current_id = my_company1.id
    user1 = User.create!(user_name: user_name1)
    Task.create!(name: task_name1, user: user1, completed: false)
    Task.create!(name: 'Task2', user: user1, completed: false)
    my_company1.id
  }
  #
  Given!(:user_name2) { 'jack_black' }
  Given!(:setup2) {
    my_company2 = MyCompany.create(company_name: 'SECOND')
    MyCompany.current_id = my_company2.id
    user2 = User.create!(user_name: user_name2)
    Task.create!(name: 'Task1', user: user2, completed: false)
    Task.create!(name: 'Task2', user: user2, completed: false)
    my_company2.id
  }
  #
  context 'checking whether the correct methods have been injected into the user' do
    Given!(:retrieve_user) {
      MyCompany.current_id = setup1
      User.where(user_name: user_name1).first
    }

    Then { expect(retrieve_user.class).to respond_to(:belongs_to)}
    Then { expect(retrieve_user.class.reflect_on_association(:my_company).present?).to eq true }
    Then { expect(retrieve_user).to respond_to(:my_company) }
  end

  context 'checking whether the correct methods have been injected into the task' do
    Given!(:retrieve_task) {
      MyCompany.current_id = setup1
      Task.where(name: task_name1).first
    }

    Then { expect(retrieve_task.class).to respond_to(:belongs_to)}
    Then { expect(retrieve_task.class.reflect_on_association(:my_company).present?).to eq true }
    Then { expect(retrieve_task).to respond_to(:my_company) }
  end

  context 'the default scope should be set on the first user' do
    Given!(:retrieve_user) {
      MyCompany.current_id = setup1
      User.where(user_name: user_name1).first
    }
    Then { expect(retrieve_user.my_company.company_name).to eq 'DEFAULT' }
    Then { expect(retrieve_user.user_name).to eq user_name1 }
  end

  context 'the default scope should be set on the second user' do
    Given!(:retrieve_user) {
      MyCompany.current_id = setup2
      User.where(user_name: user_name2).first
    }
    Then { expect(retrieve_user.my_company.company_name).to eq 'SECOND' }
    Then { expect(retrieve_user.user_name).to eq user_name2 }
  end

  context 'the default scope should be set on the first two tasks' do
    Given!(:retrieve_tasks) {
      MyCompany.current_id = setup1
      user = User.where(user_name: user_name1).first
      Task.where(user: user).all
    }
    Then {
      retrieve_tasks.each do |task|
        expect(task.my_company.company_name).to eq 'DEFAULT'
        expect(task.user.user_name).to eq user_name1
      end
    }
  end

  context 'the default scope should be set on the second two tasks' do
    Given!(:retrieve_tasks) {
      MyCompany.current_id = setup2
      user = User.where(user_name: user_name2).first
      Task.where(user: user).all
    }
    Then {
      retrieve_tasks.each do |task|
        expect(task.my_company.company_name).to eq 'SECOND'
        expect(task.user.user_name).to eq user_name2
      end
    }
  end

  context 'attempting to create a user without a my_company' do
    Given!(:test_user) { User.new }
    When { MyCompany.current_id = nil; test_user.my_company = nil; test_user.save }

    Then { expect(test_user).to have(1).errors_on(:my_company_id) }
  end

  context 'attempting to create a task without a my_company' do
    Given!(:test_task) { Task.new(name: 'test_task') }
    When { MyCompany.current_id = nil; test_task.my_company = nil; test_task.save }

    Then { expect(test_task).to have(1).errors_on(:my_company_id) }
  end

  context 'attempting to create a user when the my_company has not been set' do
    Given!(:test_user) { User.new(user_name: 'jack_black') }
    When { MyCompany.current_id = nil;  test_user.save }

    Then { expect(test_user).to have(1).errors_on(:my_company_id) }
  end

  context 'attempting to create a task when the my_company has not been set' do
    Given!(:test_task) { Task.new(name: 'test_task') }
    When { MyCompany.current_id = nil;  test_task.save }

    Then { expect(test_task).to have(1).errors_on(:my_company_id) }
  end



  context 'attempting to save a new task when the my_company has been set' do
    Given(:retrieve_task) { Task.find_by_name('test_task_2') }

    Given!(:test_company) { MyCompany.create(company_name: 'DEFAULT2') }
    Given!(:test_task) { Task.new(name: 'test_task_2') }
    When { MyCompany.current_id = test_company.id ; test_task.save }

    Then { expect(retrieve_task.my_company_id).to eq test_company.id }
  end



  context 'should raise an Error during an attempt to set the my_company to the wrong value' do
    Given(:invalid_id) { 99999 }
    Given!(:retrieve_user) {
      MyCompany.current_id = setup1
      User.where(user_name: user_name1).first
    }

    Then {
      MyCompany.current_id = invalid_id
      expect(lambda { retrieve_user.save }).to raise_error('CompanyScope::Control::CompanyAccessViolationError')
    }
  end

  context 'should raise an Error during an attempt to destroy an object whent the company is wrong' do
    Given(:invalid_id) { 99999 }
    Given!(:retrieve_user) {
      MyCompany.current_id = setup1
      User.where(user_name: user_name1).first
    }

    Then {
      MyCompany.current_id = invalid_id  # i.e. be sure its out of range!
      expect(lambda { retrieve_user.destroy }).to raise_error('CompanyScope::Control::CompanyAccessViolationError')
    }

  end

  context 'it should scope the querying of the data by the current_my_company' do
    Then { expect(Task.unscoped.all.count).to eq 4 }
    Then { expect(User.unscoped.all.count).to eq 2 }

    Then {
      MyCompany.current_id = setup1
      expect(User.all.count).to eq 1
      expect(Task.all.count).to eq 2
    }

    Then {
      MyCompany.current_id = setup2
      expect(User.all.count).to eq 1
      expect(Task.all.count).to eq 2
    }
  end

  context 'inspecting the data' do
    Then {
      #MyCompany.all.each { |c| puts "MyCompany: #{c.inspect}\n" }
      #User.all.each { |u| puts "User: #{u.inspect}\n" }
      #User.unscoped.all.each { |u| puts "User: #{u.inspect}\n" }
      #Task.unscoped.all.each { |t| puts "Task: #{t.inspect}\n" }
    }
  end
end
