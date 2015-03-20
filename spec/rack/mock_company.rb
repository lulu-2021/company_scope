# - simple MockCompany that responds to the methods that are called by the RackMiddleware
class MockCompany

  attr_reader :company_name

  def initialize(subdomain)
    @company_name = "#{subdomain}"
  end

  def self.find_by_company_name(company_name)
    MockCompany.new(company_name)
  end

  def self.table_name
    "mock_companies"
  end
end
