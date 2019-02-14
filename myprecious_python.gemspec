Gem::Specification.new do |s|
  s.name        = 'myprecious_python'
  s.version     = '0.0.6'
  s.date        = '2019-02-13'
  s.summary     = "Your precious python dependencies!"
  s.description = "A simple, markdown generated with information about your python dependencies"
  s.authors     = ["Balki Kodarapu"]
  s.email       = 'balki.kodarapu@gmail.com'
  s.files       = ["lib/myprecious_python.rb"]
  s.executables << 'myprecious_python'
  s.add_runtime_dependency 'byebug', '~> 9.0', '>= 9.0.6'
  s.add_runtime_dependency 'httparty', '~> 0.16', '>= 0.16.4'
  s.add_runtime_dependency 'json', '~> 2.1.0', '>= 2.1'
  s.add_runtime_dependency 'rest-client', '~> 2.0.2', '>= 2.0'  
  
  s.homepage    =
    'http://rubygems.org/gems/myprecious_python'
  s.license       = 'MIT'
end
