require 'rails/generators'
module CompanyScope
  class InstallGenerator < Rails::Generators::Base
    desc "CompanyScope installs the relevant database migrations"
    source_root File.expand_path("../templates", __FILE__)

    class_option :company_class_name, :type => :string, :default => 'company', :desc => "Name of Company Model"
    class_option :user_class_name, :type => :string, :default => 'user', :desc => "Name of User Model"
    class_option :enable_uuid, :type => :boolean, :default => false, :desc => "Enable UUID if the extension is used"
    class_option :no_migrations, :type => :boolean, :default => false, :desc => "Disable the creation of migrations"

    def self.source_root
      File.expand_path("../templates", __FILE__)
    end

    def modify_application_rb
      # add the company_scope configuration enabler into config/application.rb
      line = "class Application < Rails::Application"
      check_config = "config.company_scope[:configured]"
      insert_line = "#{check_config} = false"
      #unless
      gsub_file 'config/application.rb', /(#{Regexp.escape(line)})/mi do |match|
        # "#{match}\n    #{insert_line}"
        match << "#{insert_line}"
      end
    end

    def create_migrations
      unless options.no_migrations?
        Dir["#{self.class.source_root}/migrations/*.erb"].sort.each do |filepath|
          name = File.basename(filepath)
          template "migrations/#{name}", "db/migrate/#{name}"
          sleep 1
        end
      end
    end
  end
end
