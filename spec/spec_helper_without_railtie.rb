#
# - this is required during tests that are not loading rails with the railtie
#
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:include, CompanyScope::Base)
  ActiveRecord::Base.send(:include, CompanyScope::Guardian)
  ActiveRecord::Base.send(:include, CompanyScope::MultiGuardian)
end

if defined?(ActionController::Base)
  ActionController::Base.send(:include, CompanyScope::Control)
  ActionController::Base.send(:include, CompanyScope::Filter)
end
# - if this is being used in an API..
if defined?(ActionController::API)
  ActionController::API.send(:include, CompanyScope::Control)
  ActionController::API.send(:include, CompanyScope::Filter)
end
