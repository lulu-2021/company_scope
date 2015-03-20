#
module CompanyScope
  #
  module Guardian
    #
    def self.included(base)
      base.extend(GuardianClassMethods)
    end
    #
    module GuardianClassMethods
      #
      def acts_as_guardian
        #
        # ensure the column that carries the company unique id/subdomain is unique
        validates_uniqueness_of :company_name
        #
        def current_id=(id)
          RequestStore.store[:default_scope_company_id] = id
        end

        def current_id
          RequestStore.store[:default_scope_company_id]
        end
      end
    end
  end
end
