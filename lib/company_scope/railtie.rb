#
module CompanyScope
  class Railtie < Rails::Railtie
    # enable namespaced configuration in Rails environments
    config.company_scope = ActiveSupport::OrderedOptions.new
    #
    initializer, :after_initialize do |app|
      company_scope_enabled = app.config.company_scope[:configured] || false
      company_scope_model = app.config.company_scope[:company_model] || :company
      company_scope_matcher = app.config.company_scope[:company_name_matcher] || :subdomain_matcher
      #
      CompanyScope.configure do |c|
        c.enabled = company_scope_enabled
        c.company_model = company_scope_model
        c.company_name_matcher = company_scope_matcher
      end
      #
      # - this is set in the template initializer - if not by default it is disabled!
      if CompanyScope.config.enabled
        company_config = CompanyScope.config.company_model
        company_name_matcher = CompanyScope.config.company_name_matcher
        # - add MultiCompany Rack middleware to detect the company_name from the subdomain
        app.config.middleware.insert_before Rack::Runtime, Custom::MultiCompany, company_config, company_name_matcher
        # - the base module injects the default scope into company dependant models
        ActiveRecord::Base.send(:include, CompanyScope::Base)
        # - the company_entity module injects class methods for acting as the company!
        ActiveRecord::Base.send(:include, CompanyScope::Guardian)
      end
      #
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
