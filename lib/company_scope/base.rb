#
module CompanyScope
  #
  module Base
    #
    def self.included(base)
      base.extend(CompanyScopeClassMethods)
    end
    #
    module CompanyScopeClassMethods
      #
      def acts_as_company(tenant = :company)

        belongs_to tenant.to_s.underscore.to_sym

        validates_presence_of "#{tenant.to_s}_id".to_sym #:company_id

        #default_scope { where("#{self.table_name}.company_id = ?", Company.current_id) }
        default_scope { where("#{self.table_name}.#{tenant.to_s.underscore}_id = ?",
          Module.const_get("#{tenant.to_s.classify}").current_id) }

        # - on creation we make sure the company_id is set!
        before_validation(on: :create) do |obj|
          obj.send(eval(":#{tenant.to_s.underscore}_id="), Module.const_get("#{tenant.to_s.classify}").current_id)
        end

        before_save do |obj|
          # catch each time someone attempts to violate the company relationship!
          raise ::CompanyScope::Control::CompanyAccessViolationError unless
            obj.attributes["#{tenant.to_s.underscore}_id"] == Module.const_get("#{tenant.to_s.classify}").current_id
          true
        end

        before_destroy do |obj|
          # force company to be correct for current_user
          #raise ::CompanyScope::Control::CompanyAccessViolationError unless obj.company_id == Company.current_id
          raise ::CompanyScope::Control::CompanyAccessViolationError unless
            obj.attributes["#{tenant.to_s.underscore}_id"] == Module.const_get("#{tenant.to_s.classify}").current_id
          true
        end
      end
    end
  end
end
