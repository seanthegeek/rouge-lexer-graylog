# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'rouge-lexer-graylog'
  s.version     = '0.1.0'
  s.summary     = 'Rouge lexers for Graylog search queries and pipeline rules'
  s.description = 'A Rouge plugin providing syntax highlighting for Graylog search queries and pipeline rules'
  s.authors     = ['Sean Whalen']
  s.homepage    = 'https://github.com/seanthegeek/rouge-lexer-graylog'
  s.license     = 'MIT'
  s.files       = Dir['lib/**/*.rb'] + Dir['spec/demos/*'] + Dir['spec/visual/samples/*'] + ['README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'rouge', '>= 3.0'

  s.metadata = {
    'source_code_uri'   => 'https://github.com/seanthegeek/rouge-lexer-graylog',
    'bug_tracker_uri'   => 'https://github.com/seanthegeek/rouge-lexer-graylog/issues',
    'changelog_uri'     => 'https://github.com/seanthegeek/rouge-lexer-graylog/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://github.com/seanthegeek/rouge-lexer-graylog/blob/main/README.md'
  }
end
