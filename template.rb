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

# add SimpleCov
File.open("spec/spec_helper.rb", "r+") do |f|
  out = ""
  f.each do |line|
    out << line
    if line =~ /require 'rspec\/autorun'/
      out << <<-CODE.strip_heredoc
      require 'simplecov'
      SimpleCov.start 'rails'
    CODE
    end
  end
  f.pos = 0
  f.print out
  f.truncate(f.pos)
end