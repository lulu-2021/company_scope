#
# Simple AR schema that will be loaded and run in memory for each test
#
ActiveRecord::Schema.define(:version => 1) do
  create_table :my_companies, :force => true do |t|
    t.string :company_name
  end

  create_table :users, :force => true do |t|
    t.string :user_name
    t.integer :my_company_id
  end

  create_table :tasks, :force => true do |t|
    t.string :name
    t.integer :my_company_id
    t.integer :user_id
    t.boolean :completed
  end
end
