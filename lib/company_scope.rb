require "request_store"
#
require File.dirname(__FILE__) + '/custom/multi_company'
require File.dirname(__FILE__) + '/company_scope/base'
require File.dirname(__FILE__) + '/company_scope/guardian'
require File.dirname(__FILE__) + '/company_scope/control'
require File.dirname(__FILE__) + '/company_scope/filter'
require File.dirname(__FILE__) + '/company_scope/railtie' if defined? ::Rails::Railtie
#
# The config class allows the Rails Application to store configuration about the gem
#
module CompanyScope
  class Config
    attr_accessor :company_model
  end

  def self.config
    @@config ||= Config.new
  end

  def self.configure
    yield self.config
  end
end
