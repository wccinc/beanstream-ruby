#$:.unshift(File.join(File.dirname(__FILE__), 'lib'))


Gem::Specification.new do |s|
  s.name        = 'beanstream'
  s.version     = '1.0.0-rc1'
  s.date        = '2015-06-30'
  s.summary     = "Beanstream Ruby SDK"
  s.description = "Accept payments using Beanstream and Ruby"
  s.authors     = ["Brent Owens"]
  s.email       = 'bowens@beanstream.com'
  s.files       = ["lib/beanstream.rb"]
  s.homepage    ='http://developer.beanstream.com'
  s.license     = 'MIT'
  
  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']
end