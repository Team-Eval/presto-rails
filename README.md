#Presto for Rails

>Presto Logs were used to power the steam locomotive that pushed the DeLorean time machine up to 88 mph."
>
>-- [Futurepedia](http://backtothefuture.wikia.com/wiki/Presto_log)

Presto *Rails*, on the other hand, accelerates the initial setup of your amazing rails application.

##Installation

```bash
$ gem install presto-rails
```

##Usage

```bash
$ presto <your-rails-app-name>
```

##Details

Presto sets up the following defaults based on a commonly used stack at [The Flatiron School](http://flatironschool.com):

####1) Generates a new rails app without mini-test

```bash
$ rails new <your-rails-app-name> -T
```

####2) Adds development and testing gems

```ruby
group :test, :development do
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
```

####3) Initializes RSpec for the app

```bash
$ rails g rspec:install
```

####4) Configures spec_helper.rb

  a. Adds SimpleCov
   
  ```ruby
  require 'simplecov'
  SimpleCov.start 'rails'
  ```
  
  b. Comments out fixtures in favor of factory_girl
  
  ```ruby
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  ```
  
  c. Disables transactional fixtures
  
  ```ruby
  config.use_transactional_fixtures = false
  ```

  d. Adds Database Cleaner
  
  ```ruby
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
  ```

####5) Provisions specs for features

a. Adds features directory

```bash
$ mkdir -p spec/features
```

b. Adds spec/feature_helper.rb

```ruby
require 'spec_helper'
require 'capybara/rails'
```

####6) Creates Guardfile

```ruby
guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }

end
```

###Authors
[Manuel Neuhauser](http://manu3569.github.io)

[Josh Scaglione](http://github.com/j-scag)

[Logan Hasson](http://loganhasson.github.io)

###License
MIT