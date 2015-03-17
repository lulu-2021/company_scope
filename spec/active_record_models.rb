#
ActiveRecord::Schema.define(:version => 1) do
  create_table :companies, :force => true do |t|
    t.string :company_name
  end

  create_table :users, :force => true do |t|
    t.string :user_name
    t.integer :company_id
  end

  create_table :tasks, :force => true do |t|
    t.string :name
    t.integer :company_id
    t.integer :user_id
    t.boolean :completed
  end
end

class User < ActiveRecord::Base
  acts_as_company

  has_many :tasks
  validates_uniqueness_of :user_name
end

class Task < ActiveRecord::Base
  acts_as_company

  belongs_to :user
end

class Company < ActiveRecord::Base
  acts_as_guardian

  has_many :users

  validates_uniqueness_of :company_name
end
