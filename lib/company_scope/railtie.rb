require 'company_scope'
require 'rails'
#
module CompanyScope
  class Railtie < Rails::Railtie
    #
    initializer :after_initialize do
      # - the base module injects the default scope into company dependant models
      ActiveRecord::Base.send(:include, CompanyScope::Base)

      # - the company_entity module injects class methods for acting as the company!
      ActiveRecord::Base.send(:include, CompanyScope::Guardian)

      if defined?(ActionController::Base)
        # - the control module has some error handling for the application controller
        ActionController::Base.send(:include, CompanyScope::Control)
        # - the controller_filter module injects an around filter to ensure all
        # - actions in the controller are wrapped
        ActionController::Base.send(:include, CompanyScope::Filter)
      end
      # - if this is being used in an API..
      if defined?(ActionController::API)
        # - the control module has some error handling for the application controller
        ActionController::API.send(:include, CompanyScope::Control)
        # - the controller_filter module injects an around filter to ensure all
        # - actions in the controller are wrapped
        ActionController::API.send(:include, CompanyScope::Filter)
      end
    end
    #
  end
end
