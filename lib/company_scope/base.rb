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
      def store_unscoped=(unscoped)
        RequestStore.store[:company_scope_unscoped] = unscoped
      end

      def store_unscoped
        RequestStore.store[:company_scope_unscoped]
      end

      def without_company(&block)
        if block.nil?
          raise ArgumentError, "block required"
        end
        scoping_class = Module.const_get(CompanyScope.config.company_model.to_s.classify)
        cached_scoping_class_id = scoping_class.current_id # store the current company scoping
        scoping_class.current_id = nil # remove the current scoping id
        self.store_unscoped = true

        value = block.call # call the block - i.e the real AR scoping desired without the company
        return value
      ensure # finally slot the correct company scoping back into place as well as the correct old scope!
        scoping_class = Module.const_get(CompanyScope.config.company_model.to_s.classify)
        scoping_class.current_id = cached_scoping_class_id
        self.store_unscoped = false
      end

      #
      def acts_as_many_company(tenant = :company, tenant_view = :company_view)
        belongs_to tenant.to_s.underscore.to_sym

        has_many Module.const_get("#{tenant_view.to_s.classify}").table_name.to_sym,
          through: Module.const_get("#{tenant.to_s.classify}").table_name.to_sym

        acts_as_company_callbacks(tenant)
      end

      def acts_as_company(tenant = :company)
        belongs_to tenant.to_s.underscore.to_sym
        validates_presence_of "#{tenant.to_s}_id".to_sym # :company_id

        default_scope lambda {
          if self.store_unscoped != true # only scope if we haven't overriden it!
            where("#{self.table_name}.#{tenant.to_s.underscore}_id = ?",
              Module.const_get("#{tenant.to_s.classify}").current_id)
          else
            all
          end
        }

        acts_as_company_callbacks(tenant)
      end

      def acts_as_company_callbacks(tenant = :company)
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
