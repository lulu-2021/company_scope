require 'rails/generators'
module CompanyScope
  class InstallGenerator < Rails::Generators::Base
    desc "CompanyScope installs the relevant database migrations"
    source_root File.expand_path("../templates", __FILE__)

    class_option :company_class_name, :type => :string, :default => 'company', :desc => "Name of Company Model"
    class_option :user_class_name, :type => :string, :default => 'user', :desc => "Name of User Model"
    class_option :no_migrations, :type => :boolean, :default => false, :desc => "Disable the creation of migrations"

    def self.source_root
      File.expand_path("../templates", __FILE__)
    end

    def modify_application_rb
      # add the company_scope configuration enabler into config/application.rb
      config_file = 'config/application.rb'
      line = "class Application < Rails::Application"
      insert_config = <<-RUBY
        config.company_scope[:configured] = false
      RUBY
      if File.readlines(config_file).grep(/config.company_scope\[:configured\] = false/).size == 0
        gsub_file config_file, /(#{Regexp.escape(line)})/mi do |match|
          match << "\n#{insert_config}"
        end
      end
    end

    def add_scoping_to_application_controller
      controller_file = 'app/controllers/application_controller.rb'
      line = 'class ApplicationController < ActionController::Base'
      insert_company_scope = <<-RUBY
        company_setup\n
        set_scoping_class :company\n
        acts_as_company_filter\n
      RUBY
      if File.readlines(controller_file).grep(/company_setup/).size == 0
        gsub_file controller_file, /(#{Regexp.escape(line)})/mi do |match|
          match << "\n#insert_company_scope"
        end
      end
    end

    def generate_company_migration
      unless options.no_migrations?
        # - generate a company model and migration with a 50 char max on the company name and unique index
        generate(:model, :company, 'company_name:string{50}:uniq' )
      end
    end

    def generate_user_migration
      unless options.no_migrations?
        # - generate a user model and migration with a company_id reference a few basic user auth fields
        migrate_user_model = <<-RUBY
          company_id:id
          password_hash:string
          password_salt:string
          first_name:string{50}
          last_name:string{50}
          user_name:string{50}:uniq
          email_address:string{100}:uniq
        RUBY
        generate(:model, :user, "#{migrate_user_model.gsub("\n", " ")}")
      end
    end

    def make_company_the_guardian
      # - add the acts_as_guardian company_scope module into the company model
      unless options.no_migrations?
        config_file = 'app/models/company.rb'
        line = "class Company < ActiveRecord::Base"
        insert_guardian_scope = "acts_as_guardian"
        if File.readlines(config_file).grep(/acts_as_guardian/).size == 0
          gsub_file config_file, /(#{Regexp.escape(line)})/mi do |match|
            match << "\n#{insert_guardian_scope}"
          end
        end
      end
    end

    def make_user_a_tenant
      # - add the acts_as_company company_scope module into the user model
      unless options.no_migrations?
        config_file = 'app/models/user.rb'
        line = "class User < ActiveRecord::Base"
        insert_tenant_scope = "acts_as_company"
        if File.readlines(config_file).grep(/acts_as_company/).size == 0
          gsub_file config_file, /(#{Regexp.escape(line)})/mi do |match|
            match << "\n#{insert_tenant_scope}"
          end
        end
      end
    end

  end
end
