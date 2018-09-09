Gem::Specification.new do |s|
  s.name        = 'prospectus_travis'
  s.version     = '0.0.4'
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.summary     = 'Prospectus helpers for TravisCI'
  s.description = 'Prospectus helpers for TravisCI'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/prospectus_travis'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split

  s.add_dependency 'keylime', '~> 0.2.1'
  s.add_dependency 'prospectus', '~> 0.8.0'
  s.add_dependency 'travis', '~> 1.8.9'

  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'fuubar', '~> 2.3.0'
  s.add_development_dependency 'goodcop', '~> 0.5.0'
  s.add_development_dependency 'rake', '~> 12.3.0'
  s.add_development_dependency 'rspec', '~> 3.8.0'
  s.add_development_dependency 'rubocop', '~> 0.58.0'
end
