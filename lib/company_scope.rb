require "request_store"
#
require File.dirname(__FILE__) + '/rack/multi_company'
require File.dirname(__FILE__) + '/company_scope/base'
require File.dirname(__FILE__) + '/company_scope/guardian'
require File.dirname(__FILE__) + '/company_scope/control'
require File.dirname(__FILE__) + '/company_scope/filter'
require File.dirname(__FILE__) + '/company_scope/railtie' if defined? ::Rails::Railtie

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:include, CompanyScope::Base)
  ActiveRecord::Base.send(:include, CompanyScope::Guardian)
end

if defined?(ActionController::Base)
  ActionController::Base.send(:include, CompanyScope::Control)
  ActionController::Base.send(:include, CompanyScope::Filter)
end
# - if this is being used in an API..
if defined?(ActionController::API)
  ActionController::API.send(:include, CompanyScope::Control)
  ActionController::API.send(:include, CompanyScope::Filter)
end

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
