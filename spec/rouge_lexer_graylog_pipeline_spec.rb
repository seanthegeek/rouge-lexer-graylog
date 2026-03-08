# frozen_string_literal: true

require 'minitest/autorun'
require 'rouge'
require 'rouge/lexer/graylog_pipeline'

class RougeGraylogPipelineLexerTest < Minitest::Test
  def setup
    @lexer = Rouge::Lexers::GraylogPipeline.new
  end

  def test_finds_by_tag
    assert_equal Rouge::Lexers::GraylogPipeline, Rouge::Lexer.find('graylog-pipeline')
  end

  def test_finds_by_alias_graylog_rule
    assert_equal Rouge::Lexers::GraylogPipeline, Rouge::Lexer.find('graylog-rule')
  end

  def test_finds_by_alias_graylog_rules
    assert_equal Rouge::Lexers::GraylogPipeline, Rouge::Lexer.find('graylog-rules')
  end

  def test_guesses_by_mimetype
    assert_equal Rouge::Lexers::GraylogPipeline, Rouge::Lexer.guess(mimetype: 'text/x-graylog-pipeline')
  end

  def test_demo_preserves_input
    demo = load_demo
    output = @lexer.lex(demo).map { |_, val| val }.join
    assert_equal demo, output, 'Lexer output does not reconstruct the demo input'
  end

  def test_sample_preserves_input
    sample = load_sample
    output = @lexer.lex(sample).map { |_, val| val }.join
    assert_equal sample, output, 'Lexer output does not reconstruct the sample input'
  end

  def test_no_error_tokens_in_demo
    errors = collect_errors(load_demo)
    assert_empty errors, "Demo produced error tokens:\n#{format_errors(errors)}"
  end

  def test_no_error_tokens_in_sample
    errors = collect_errors(load_sample)
    assert_empty errors, "Visual sample produced error tokens:\n#{format_errors(errors)}"
  end

  private

  def load_demo   = File.read(File.join(__dir__, 'demos', 'graylog_pipeline'))
  def load_sample = File.read(File.join(__dir__, 'visual', 'samples', 'graylog_pipeline'))

  def collect_errors(text)
    @lexer.lex(text).select { |tok, _| tok == Rouge::Token::Tokens::Error }
  end

  def format_errors(errors)
    errors.map { |_, val| "  #{val.inspect}" }.join("\n")
  end
end
