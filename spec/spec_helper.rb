require 'coveralls'
Coveralls.wear!
#
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
#
ENV["RAILS_ENV"] ||= 'test'
#
require 'rspec'
require 'rspec/given'
require 'rack'
#
# Require All of Rails
#require 'rails/all'
# Or only require the pieces of the rails stack we are testing.
require 'active_record'
require 'action_controller/railtie'
require 'rails/test_unit/railtie'
#
#
require 'rspec/rails'
require 'rspec/collection_matchers'
require 'request_store'
require 'active_record_helper'
#
require 'company_scope'
require 'subdomain_matcher'
#
