Gem::Specification.new do |s|
  s.name = 'sequel-pg-trgm'
  s.version = '0.0.1'
  s.date = '2014-04-13'
  s.summary = 'sequel-pg-trgm'
  s.authors = ['Mitchell Henke']
  s.email = 'mitchh23@gmail.com'
  s.files = ['lib/sequel/extensions/pg_trgm.rb', 'lib/sequel/plugins/pg_trgm.rb']
  s.homepage = 'https://github.com/mitchellhenke/sequel-pg-trgm'
  s.license = 'MIT'

  s.add_dependency 'sequel', '> 3.0'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'pg', '~> 0.17'
end
