require 'spec_helper'
#require 'railties'
#require "isolation/abstract_unit"

class RailtieTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::Isolation

  def setup
    build_app
    boot_rails
    require 'rails/all'
  end

  def app
    @app ||= Rails.application
  end

  test "railtie test" do
    require 'company_scope/railtie'

    assert_equal :company, config.company_scope[:company_model]
  end

end

describe CompanyScope::Railtie do

Given!(:setup){

}

end
