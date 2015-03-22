#
# Simple set of AR models that will be loaded with each test
#
class User < ActiveRecord::Base
  acts_as_company :my_company

  has_many :tasks
  validates_uniqueness_of :user_name
end

class Task < ActiveRecord::Base
  acts_as_company :my_company

  belongs_to :user
end

class MyCompany < ActiveRecord::Base
  acts_as_guardian

  has_many :users
end
