#
module Rack
  #
  class CompanyError
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue CompanyScope::Control::CompanyAccessViolationError => error
        error_output = "You tried to access a company that does not exist : #{error}"
        return [
          400, { "Content-Type" => "application/txt" },
          [ { status: 400, error: error_output } ]
        ]
      end
    end
  end
end
