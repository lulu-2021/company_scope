#
module Rack
  #
  class CompanyError
    attr_accessor :error_path
    def initialize(app, error_path)
      @app = app
      @error_path = error_path
    end

    def call(env)
      begin
        @app.call(env)
      rescue CompanyScope::Control::CompanyAccessViolationError => error
        error_output = "You tried to access a company that does not exist : #{error}"
        error_file = "#{error_path}/404.html"
        if File.file?(error_file) && File.readable?(error_file)
          return render_format(status, 'text/html', File.read(path))
        else
          return [404, { "X-Cascade" => "pass" }, [ { status: 404, error: error_output }.to_html ]]
        end
      end
    end

    def render_error(status, content_type, body)
      [status, {'Content-Type' => "#{content_type}; charset=#{ActionDispatch::Response.default_charset}",
                'Content-Length' => body.bytesize.to_s}, [body]]
    end
  end
end