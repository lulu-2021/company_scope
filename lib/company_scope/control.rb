module CompanyScope
  module Control
    class CompanyAccessViolationError < SecurityError; end

    # - rescue from errors relating to the wrong company to avoid cross company data leakage
    rescue_from CompanyScope::Controler::CompanyAccessViolationError, with: :company_scope_company_not_set

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
