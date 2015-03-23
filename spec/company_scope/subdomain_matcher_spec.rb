require 'spec_helper'

describe SubdomainMatcher do

  Given(:test_host_name) { 'default.lvh.me' }
  Given(:test_request) { double('Request', host: test_host_name) }

  context 'has must have a to_domain method' do
    Then { expect(SubdomainMatcher).to respond_to(:to_domain) }
  end

  context 'it must correctly split the first segment of the domain' do
    Given!(:subdomain) { SubdomainMatcher.to_domain(test_request) }

    Then { expect(subdomain).to eq 'DEFAULT' }
  end
end
