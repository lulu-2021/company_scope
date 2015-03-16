require 'company_scope'
require 'rails'
#
module CompanyScope
  class RailTie
    initializer :after_initialize do
      ActiveRecord::Base.send(:include, CompanyScope::Base)
    end
  end
end
