#
module CompanyScope
  #
  module MultiGuardian
    #
    def self.included(base)
      base.extend(MultiGuardianClassMethods)
    end
    #
    module MultiGuardianClassMethods
      #
      def acts_as_multi_guardian
        #
        # this should just be a list of company ids that this scope is setting
        #
        def current_ids=(ids)
          RequestStore.store[:default_scope_company_ids] = ids
        end

        def current_ids
          RequestStore.store[:default_scope_company_ids]
        end
      end
    end
  end
end
