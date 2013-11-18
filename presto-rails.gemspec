Gem::Specification.new do |s|
  s.name        = 'presto-rails'
  s.version     = '0.0.6'
  s.executables << 'presto'
  s.date        = '2013-11-06'
  s.summary     = "presto-rails gem"
  s.description = "Sets up a rails application using the default Flatiron School stack."
  s.authors     = ["Logan Hasson", "Josh Scaglione", "Manuel Neuhauser" ]
  s.email       = "teamevalruby@gmail.com"
  s.files       = Dir["{bin,lib,templates}/*"]
  s.homepage    =
    'http://rubygems.org/gems/presto-rails'
  s.license       = 'MIT'
  s.add_runtime_dependency('rails', '>= 4.0.0')
end