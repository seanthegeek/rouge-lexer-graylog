# frozen_string_literal: true

require 'rouge'
require_relative 'lib/rouge/lexer/graylog_query'
require_relative 'lib/rouge/lexer/graylog_pipeline'

targets = [
  { tag: 'graylog-query',    file: 'graylog_query' },
  { tag: 'graylog-pipeline', file: 'graylog_pipeline' }
]

filter = ARGV.first
targets.select! { |t| t[:file].include?(filter) } if filter

targets.each do |entry|
  lexer       = Rouge::Lexer.find(entry[:tag])
  sample_path = File.join(__dir__, 'spec', 'visual', 'samples', entry[:file])
  sample      = File.read(sample_path)

  puts "\n=== #{entry[:tag]} ===\n"
  if ENV['DEBUG']
    lexer.lex(sample) { |tok, val| puts "#{tok.qualname.ljust(30)} #{val.inspect}" }
  else
    formatter = Rouge::Formatters::Terminal256.new(Rouge::Themes::Github.new)
    puts formatter.format(lexer.lex(sample))
  end
end
