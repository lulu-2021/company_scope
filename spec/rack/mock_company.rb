# - simple MockCompany that responds to the methods that are called by the RackMiddleware
#
class MockCompany

  attr_reader :company_name

  def initialize(subdomain)
    @company_name = "#{subdomain}"
  end

  def self.find_by_company_name(company_name)
    if company_name == 'DEFAULT'
      MockCompany.new(company_name)
    elsif company_name.downcase == 'badtenant'
      nil
    else
      MockCompany.new('BAD')
    end
  end

  def id
    if company_name == 'DEFAULT'
      'DEFAULT_ID'
    else
      'BAD_ID'
    end
  end

  def self.table_name
    "mock_companies"
  end
end
