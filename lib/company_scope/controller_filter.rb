#
module CompanyScope
  #
  module ControllerFilter
    #
    def self.included(base)
      base.extend(ControllerFilterClassMethods)
    end

    module ControllerFilterClassMethods
      #
      def acts_as_company_filter
        around_filter :filter_by_current_company_scope
      end

      def filter_by_current_company_scope
        Company.current_id = current_company.id
        yield
      ensure
        Company.current_id = nil
      end
    end
  end
end
