Gem::Specification.new do |s|
  s.name        = 'jira_cmd'
  s.version     = '0.1.0'
  s.date        = '2013-07-31'
  s.summary     = "Command line interface for interacting with Jira"
  s.description = "Just a litte script to query Jira from the command line"
  s.authors     = ["John Brosnan"]
  s.email       = 'john@thepond.com'
  s.files       = ["lib/jira_cmd.rb"]
  s.executables = ['jira']
  s.homepage    = ''
  s.license     = 'MIT'
  s.add_dependency('nokogiri', '~> 1.5.9')
  s.add_dependency('mixlib-cli', '~> 1.2.2')
end
