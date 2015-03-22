#
module CompanyScope
  class Railtie < Rails::Railtie
    # enable namespaced configuration in Rails environments
    config.company_scope = ActiveSupport::OrderedOptions.new
    #
    initializer :after_initialize do |app|
      #
      puts "\nLoading Railtie after_initialize..\n"
      #
      CompanyScope.configure do |config|
        config.company_model = app.config.company_scope[:company_model]
      end

      # - retrieve the company_scope - model name - usually set in application.rb
      company_config = app.config.company_scope[:company_model] || :company

      # - add MultiCompany Rack middleware to detect the company_name from the subdomain
      app.config.middleware.insert_after Rack::Sendfile, Rack::MultiCompany, company_config

      app.config.middleware.insert_after Rack::MultiCompany, Rack::CompanyError

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
