#
module Custom
  #
  class CompanyError
    #
    attr_reader :company_class_name
    #
    def initialize(app, company_class_name)
      @app = app
      @company_class_name = company_class_name
    end

    def call(env)
      @app.call(env)
      env['COMPANY_SCOPE_ERROR'] = 'RENDERED_INVALID_COMPANY_ERROR'
      render_exception(env)
    end

    def render_exception(env)
      error_output = "You tried to access a company that does not exist : #{@company_class_name}"
      error_file = "/public/invalid_company.html"
      if ::File.exist?(error_file)
        return render_error(status, 'text/html', ::File.read(error_file))
      else
        return [404, { "X-Cascade" => "pass" }, [ { status: 404, error: error_output }.to_s ]]
      end
    end

    def render_error(status, content_type, body)
      [status, {'Content-Type' => "#{content_type}; charset=#{ActionDispatch::Response.default_charset}",
                'Content-Length' => body.bytesize.to_s}, [body]]
    end
  end
end
