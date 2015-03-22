require 'spec_helper'
#
describe CompanyScope::Config do
  Given(:config) {
    CompanyScope.configure do |config|
      config.company_model = :test_company
    end
    CompanyScope.config
  }

  Then{ expect(config.company_model).to eq :test_company }
end
