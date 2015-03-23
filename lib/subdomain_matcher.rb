#
class SubdomainMatcher
  def self.to_domain(request)
    first_sub_domain = request.host.split('.').first
    # disallow any non alphabetic chars!
    domain = first_sub_domain.upcase if first_sub_domain.match(/\A[a-zA-Z0-9]*\z/)
  end
end
