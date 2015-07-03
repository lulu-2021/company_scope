require 'rails/generators'
module CompanyScope
  class InstallGenerator < Rails::Generators::Base
    desc "CompanyScope installs the relevant database migrations"
    source_root File.expand_path("../templates", __FILE__)

    class_option :company_class_name, :type => :string, :default => 'company', :desc => "Name of Company Model"
    class_option :user_class_name, :type => :string, :default => 'user', :desc => "Name of User Model"
    class_option :enable_uuid, :type => boolean, :default => false, :desc => "Enable UUID if the extension is used"

    def self.source_root
      File.expand_path("../templates", __FILE__)
    end

    def modify_application_rb
      line = "class Application < Rails::Application"
      gsub_file 'config/environments/production.rb', /(#{Regexp.escape(line)})/mi do |match|
        "class Application < Rails::Application"
        "  config.company_scope[:configured] = false"
      end
    end

    def create_migrations
      Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
        name = File.basename(filepath)
        template "migrations/#{name}", "db/migrate/#{name}"
        sleep 1
      end
    end
  end
end
