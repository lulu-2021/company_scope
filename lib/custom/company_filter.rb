#
module Custom
  #
  class CompanyFilter
    def initialize(app, company_class)
      @app = app
      @company_class_name = company_class
    end

    def call(env)
      multi_company_middleware = Custom::MultiCompany.new(@app, @company_class_name)
      invalid_company_middleware = Custom::CompanyError.new(@app, @company_class_name)
      # - always call the MultiCompany Middleware!
      env = multi_company_middleware.call(env)
      if env['COMPANY_SCOPE_ERROR'] == 'INVALID_COMPANY_ERROR'
        # - only call the InvalidCompany middleware when we have an issue!
        env = invalid_company_middleware.call(env)
      end
      response = @app.call(env)
      response
    end
  end
end
