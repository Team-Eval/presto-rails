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

system("bundle > /dev/null")
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
  f.print out.chomp
  f.truncate(f.pos)
end

# make spec/features directory
run('mkdir -p spec/features')

# create feature_helper.rb
file 'spec/feature_helper.rb', <<-CODE.strip_heredoc.chomp
  require 'spec_helper'
  require 'capybara/rails'
CODE

# setup Guardfile
file 'Guardfile', %q(
  guard 'rails' do
    watch('Gemfile.lock')
    watch(%r{^(config|lib)/.*})
  end


  guard :rspec do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }

    # Rails example
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
    watch('config/routes.rb')                           { "spec/routing" }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }

    # Capybara features specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/features/#{m[1]}_spec.rb" }

    # Turnip features and steps
    watch(%r{^spec/acceptance/(.+)\.feature$})
    watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
  end
).strip.gsub(/^ {2}/, '')