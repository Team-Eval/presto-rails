# add development and testing gems
gem_group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'terminal-notifier-guard'
  gem 'factory_girl_rails'
  gem 'simplecov'
  gem 'database_cleaner'
  gem 'guard', '>=2.1.0'
  gem 'guard-rspec'
end

# setup RSpec: rails g rspec:install
generate(:"rspec:install")

# edit spec/spec_helper.rb
File.open("spec/spec_helper.rb", "r+") do |f|
  out = ""
  f.each do |line|
    if line =~ /require 'rspec\/autorun'/
      # add SimpleCov
      out << line
      out << <<-CODE.strip_heredoc
      require 'simplecov'
      SimpleCov.start 'rails'
    CODE
    elsif line =~ /config\.fixture_path/
      # comment out fixtures
      out << "  ##{line[1..-1]}"
    elsif line =~ /config\.use_transactional_fixtures/
      # set transactional fixtures to false
      out << line.sub("true", "false")
    elsif line =~ /RSpec\.configure do/
      # add Database Cleaner
      out << line
      out << <<-CODE.gsub(/^ {6}/, '')
        config.before(:suite) do
          DatabaseCleaner.strategy = :transaction
          DatabaseCleaner.clean_with(:truncation)
        end

        config.before(:each) do
          DatabaseCleaner.start
        end

        config.after(:each) do
          DatabaseCleaner.clean
        end
      CODE
    else
      out << line
    end
  end
  f.pos = 0
  f.print out
  f.truncate(f.pos)
end

# make spec/features directory
run('mkdir -p spec/features')

# create feature_helper.rb
file 'spec/feature_helper.rb', <<-CODE.strip_heredoc
  require 'spec_helper'
  require 'capybara/rails'
CODE

# initialize Guard
run('guard init')