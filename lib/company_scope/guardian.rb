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
        #puts "\n\n\n Class Name: #{self.class.to_s.downcase}\n\n\n"
        #validates_uniqueness_of "#{self.class.to_s.downcase}_name".to_sym #:company_name
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
