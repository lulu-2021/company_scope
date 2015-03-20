# - simple MockCompany that responds to the methods that are called by the RackMiddleware
class MyCompany

  attr_reader :company_name

  def initialize(subdomain)
    @company_name = "#{subdomain}"
  end

  def self.find_by_company_name(company_name)
    MyCompany.new(company_name)
  end

  def self.table_name
    "my_companies"
  end
end
