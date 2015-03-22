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

      def current_company_id
        @company_id = request.env["COMPANY_ID"]
        raise CompanyScope::Control::CompanyAccessViolationError if @company_id.nil?
        @company_id
      end

      def filter_by_current_company_scope
        scope_class.current_id = current_company_id
        yield
      ensure
        scope_class.current_id = nil
      end
    end

    module FilterClassMethods
      # - the default is set by the Rails application configuration!
      def set_scoping_class(scope_model = :company)
        self.class_eval do
          cattr_accessor :scope_class
        end
        self.scope_class = scope_model.to_s.camelcase.constantize
      end
      #
      def company_setup
        helper_method :current_company
        set_scoping_class Rails.application.config.company_scope[:company_model]
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
        rescue_from CompanyScope::Control::CompanyAccessViolationError, with: :company_scope_company_not_set
      end

      def company_scope_company_not_set
        flash[:error] = t('application.warnings.company_not_set')
        return head(:forbidden)
        #if wrong_company_path.nil?
        #  redirect_to(root_path) and return
        #else
        #  redirect_to(wrong_company_path) and return
        #end
      end
    end
  end
end
