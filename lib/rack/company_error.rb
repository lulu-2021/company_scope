#
module Rack
  #
  class CompanyError
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
      rescue CompanyScope::Control::CompanyAccessViolationError => error
        return [
          400, { "Content-Type" => "application/txt" },
          [ { status: 400, error: error_output } ]
        ]
      else
        raise error
      end
    end
  end
end
