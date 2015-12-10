#
module CompanyScope
  #
  module Base
    #
    def self.included(base)
      base.extend(CompanyScopeClassMethods)

      private
      def set_company_id(tenant, obj)
        obj.send(eval(":#{tenant.to_s.underscore}_id="), Module.const_get("#{tenant.to_s.classify}").current_id)
      end
    end
    #
    module CompanyScopeClassMethods
      #
      def acts_as_company(tenant = :company)

        belongs_to tenant.to_s.underscore.to_sym

        validates_presence_of "#{tenant.to_s}_id".to_sym #:company_id

        default_scope { where("#{self.table_name}.#{tenant.to_s.underscore}_id = ?",
          Module.const_get("#{tenant.to_s.classify}").current_id) }

        # - on intialize & creation we make sure the company_id is set!
        after_initialize { |obj| set_company_id(tenant, obj) }
        before_validation(on: :create) { |obj| set_company_id(tenant, obj) }

        # - before we save - catch each time someone attempts to violate the company relationship!
        before_save do |obj|
          raise ::CompanyScope::Control::CompanyAccessViolationError unless
            obj.attributes["#{tenant.to_s.underscore}_id"] == Module.const_get("#{tenant.to_s.classify}").current_id
          true
        end

        before_destroy do |obj|
          # force company to be correct for current_user
          raise ::CompanyScope::Control::CompanyAccessViolationError unless
            obj.attributes["#{tenant.to_s.underscore}_id"] == Module.const_get("#{tenant.to_s.classify}").current_id
          true
        end
      end
    end
  end
end
