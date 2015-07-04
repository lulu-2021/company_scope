#
require 'spec_helper'
#
# This dummy class is needed since the during the application load the class does not
# yet exist.. it will be overwritten by the version in active_record_models
CompanyScope.config.enabled = false
#
class MyCompany < ActiveRecord::Base; end
#
require 'spec_helper_load_application'
#
require 'active_record_models'
require 'active_record_schema'
#
class DummyCompany < ActiveRecord::Base; end
class DummyUser < ActiveRecord::Base; end
#
describe CompanyScope::Railtie do
  #
  context 'after initialisation the company should have the scoping methods' do
    Then { expect(DummyCompany).to respond_to(:acts_as_guardian) }
    Then { expect(ActiveRecord::Base).to respond_to(:acts_as_guardian) }
  end

  context 'after initialisation the user should have the scoping methods' do
    Then { expect(DummyUser).to respond_to(:acts_as_company) }
    Then { expect(ActiveRecord::Base).to respond_to(:acts_as_company) }
  end

  context 'after initialisation the App should have the company scoping model configured' do
    Then { expect(Rails.application.config.company_scope[:company_model]).to eq :my_company }
  end

  context 'the company scope configuration should have happened' do
    Then { expect(CompanyScope.config.enabled).to be false }
  end
end
