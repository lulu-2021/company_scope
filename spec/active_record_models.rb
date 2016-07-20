#
# Simple set of AR models that will be loaded with each test
#
class MyCompany < ActiveRecord::Base
  acts_as_guardian

  has_many :users
end

class MyCompanyView < ActiveRecord::Base
  acts_as_multi_guardian

  belongs_to :lead
  belongs_to :my_company
end

class User < ActiveRecord::Base
  acts_as_company :my_company

  has_many :tasks
  validates_uniqueness_of :user_name
end

class Task < ActiveRecord::Base
  acts_as_company :my_company

  belongs_to :user
end

class Lead < ActiveRecord::Base
  acts_as_many_company :my_company, :my_company_view
end
