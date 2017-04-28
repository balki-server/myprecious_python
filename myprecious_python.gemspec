Gem::Specification.new do |s|
  s.name        = 'myprecious_python'
  s.version     = '0.0.3'
  s.date        = '2017-04-26'
  s.summary     = "Your precious python dependencies!"
  s.description = "A simple, markdown generated with information about your python dependencies"
  s.authors     = ["Balki Kodarapu"]
  s.email       = 'balki.kodarapu@gmail.com'
  s.files       = ["lib/myprecious_python.rb"]
  s.executables << 'myprecious_python'
  s.add_runtime_dependency 'nokogiri', '~> 1.7', '>= 1.7.0'
  s.add_runtime_dependency 'byebug', '~> 9.0', '>= 9.0.6'
  s.homepage    =
    'http://rubygems.org/gems/myprecious_python'
  s.license       = 'MIT'
end
