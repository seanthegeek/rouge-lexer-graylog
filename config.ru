# frozen_string_literal: true

require 'rouge'
require_relative 'lib/rouge/lexer/graylog_query'
require_relative 'lib/rouge/lexer/graylog_pipeline'

app = proc do |_env|
  formatter = Rouge::Formatters::HTML.new
  theme_css = Rouge::Themes::Github.render(scope: '.highlight')

  lexers = [
    { lexer: Rouge::Lexer.find('graylog-query'),    name: 'Query',    demo: 'graylog_query',    sample: 'graylog_query' },
    { lexer: Rouge::Lexer.find('graylog-pipeline'), name: 'Pipeline', demo: 'graylog_pipeline', sample: 'graylog_pipeline' }
  ]

  sections = lexers.map do |entry|
    lexer = entry[:lexer]
    demo_path   = File.join(__dir__, 'spec', 'demos',          entry[:demo])
    sample_path = File.join(__dir__, 'spec', 'visual', 'samples', entry[:sample])
    demo   = File.exist?(demo_path)   ? File.read(demo_path)   : '(no demo found)'
    sample = File.exist?(sample_path) ? File.read(sample_path) : '(no visual sample found)'

    <<~HTML
      <h2>#{entry[:name]} Lexer — Demo</h2>
      <div class="highlight"><pre>#{formatter.format(lexer.lex(demo))}</pre></div>
      <h2>#{entry[:name]} Lexer — Visual Sample</h2>
      <div class="highlight"><pre>#{formatter.format(lexer.lex(sample))}</pre></div>
    HTML
  end.join

  body = <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>Rouge Lexer Preview: Graylog</title>
      <style>#{theme_css} body { font-family: sans-serif; margin: 2em; }</style>
    </head>
    <body>
      <h1>Graylog Lexer Preview</h1>
      #{sections}
    </body>
    </html>
  HTML

  ['200', { 'content-type' => 'text/html' }, [body]]
end

run app
