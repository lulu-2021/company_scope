require 'spec_helper'
require 'active_record_models'
#
class DummyCompany < ActiveRecord::Base; end
class DummyUser < ActiveRecord::Base; end
#
describe CompanyScope::Railtie do
  #
  context 'after initialisation the company should have the scoping methods' do
    Given!(:railtie) { CompanyScope::Railtie.send(:new) }

    Then { expect(railtie).not_to be nil }
    Then { expect(DummyCompany).to respond_to(:acts_as_guardian) }
    Then { expect(ActiveRecord::Base).to respond_to(:acts_as_guardian) }
  end

  context 'after initialisation the user should have the scoping methods' do
    Given!(:railtie) { CompanyScope::Railtie.send(:new) }

    Then { expect(railtie).not_to be nil }
    Then { expect(DummyUser).to respond_to(:acts_as_company) }
    Then { expect(ActiveRecord::Base).to respond_to(:acts_as_company) }
  end
end
