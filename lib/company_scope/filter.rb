#
module CompanyScope
  #
  module Filter
    #
    def self.included(base)
      base.extend(TopLevelClassMethods)
      base.extend(FilterClassMethods)
      base.include(FilterMethods)
    end

    module FilterMethods

      def current_company
        request.env["COMPANY_ID"] # a default that is best overridden in the application controller..
      end

      def filter_by_current_company_scope
        scope_class.current_id = current_company.id
        yield
      ensure
        scope_class.current_id = nil
      end
    end

    module FilterClassMethods
      #
      def set_scoping_class(scope_model = :company)
        self.class_eval do
          cattr_accessor :scope_class
        end
        self.scope_class = scope_model.to_s.camelcase.constantize
      end
      #
      def company_setup
        helper_method :current_company
      end
      #
      def acts_as_company_filter
        around_filter :filter_by_current_company_scope
      end
    end
    #
    module TopLevelClassMethods
      #
      def rescue_from_company_access_violations
        # - rescue from errors relating to the wrong company to avoid cross company data leakage
        rescue_from ::CompanyScope::Control::CompanyAccessViolationError, with: :company_scope_company_not_set
      end

      def company_scope_company_not_set
        flash[:error] = t('application.warnings.company_not_set')
        if wrong_company_path.nil?
          redirect_to(root_path) and return
        else
          redirect_to(wrong_company_path) and return
        end
      end
    end
  end
end
