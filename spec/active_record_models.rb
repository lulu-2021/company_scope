#
ActiveRecord::Schema.define(:version => 1) do
  create_table :companies, :force => true do |t|
    t.column :company_name, :string
  end

  create_table :users, :force => true do |t|
    t.column :user_name, :string
    t.column :company_id, :integer
  end

  create_table :tasks, :force => true do |t|
    t.column :name, :string
    t.column :company_id, :integer
    t.column :user_id, :integer
    t.column :completed, :boolean
  end
end

class Company < ActiveRecord::Base
  acts_as_guardian

  has_many :users
end

class User < ActiveRecord::Base
  acts_as_company

  has_many :tasks
end

class Task < ActiveRecord::Base
  acts_as_company

  belongs_to :user
end
