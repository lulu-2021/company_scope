require 'database_cleaner'
#
ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
#
#
RSpec.configure do |config|
  #
  config.filter_run_excluding :suspended => true
  config.infer_base_class_for_anonymous_controllers = true
  #
  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end
  #
  config.before(:each) do
    DatabaseCleaner[:active_record].start
  end
  #
  config.after(:each) do
    DatabaseCleaner[:active_record].clean
  end
  #
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
