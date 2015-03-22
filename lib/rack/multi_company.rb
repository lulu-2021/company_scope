#
module Rack
  #
  class MultiCompany
    #
    attr_reader :company_class_name
    #
    def initialize(app, company_class)
      @app = app
      @company_class_name = company_class.to_s.split('_').collect!{ |w| w.capitalize }.join
      @company = Module.const_get(@company_class_name).find_by_company_name('DEFAULT') if db_configured
    end

    def call(env)
      request = Rack::Request.new(env)
      first_sub_domain = request.host.split('.').first
      # disallow any non alphabetic chars!
      domain = first_sub_domain.upcase if first_sub_domain.match(/\A[a-zA-Z0-9]*\z/)
      # insert the company into ENV - for the controller helper_method 'current_company'
      retrieve_company_from_subdomain(domain)
      env['COMPANY_ID'] = @company.id unless @company.nil?
      puts "\n\n Rack MultiCompany setting COMPANY_ID env: #{env['COMPANY_ID']}"
      response = @app.call(env)
      response
    end

    private

    def db_configured
      ActiveRecord::Base.connection.table_exists? Module.const_get(@company_class_name).table_name
    end

    def retrieve_company_from_subdomain(domain)
      # - During test runs we load a company called 'DEFAULT' - it does not need to exist during initialisation
      @company = Module.const_get(@company_class_name).find_by_company_name('DEFAULT') if Rails.env == 'test'
      # - only ever load the company when the subdomain changes - also works when company is nil from an unsuccessful attempt..
      @company = Module.const_get(@company_class_name).find_by_company_name(domain) unless ( domain == @company.company_name )
      raise CompanyScope::Control::CompanyAccessViolationError if @company == nil
      @company
    end
  end
end
