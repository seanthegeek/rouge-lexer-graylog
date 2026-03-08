# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class GraylogQuery < RegexLexer
      title 'Graylog Query'
      desc 'Graylog search query syntax'
      tag 'graylog-query'
      aliases 'graylog-search'
      mimetypes 'text/x-graylog-query'

      # Boolean operators from Graylog search query documentation
      def self.bool_operators
        @bool_operators ||= Set.new %w(AND OR NOT)
      end

      # Range keyword from Graylog search query documentation
      def self.range_keywords
        @range_keywords ||= Set.new %w(TO)
      end

      # Magic fields from Graylog search query documentation
      def self.magic_fields
        @magic_fields ||= Set.new %w(_exists_ _missing_)
      end

      def self.detect?(text)
        # Detect field:value syntax, boolean operators, or magic fields
        return true if text =~ /\b(?:AND|OR|NOT)\b/
        return true if text =~ /\b_(?:exists|missing)_:/
        return true if text =~ /\w+:[^\s\/]/
        false
      end

      state :root do
        rule %r/\s+/, Text::Whitespace

        # Regex literals: /pattern/
        rule %r(/), Str::Regex, :regex_literal

        # Double-quoted strings / phrases
        rule %r/"/, Str::Double, :double_string

        # Magic fields: _exists_:fieldname, _missing_:fieldname
        # Must come before generic field:value rule
        rule %r/(_exists_|_missing_)(\s*)(:)/ do
          groups Name::Variable::Magic, Text::Whitespace, Punctuation
        end

        # Field name followed by colon: fieldname:
        rule %r/([a-zA-Z_][a-zA-Z0-9_.@\-]*)(\s*)(:)/ do
          groups Name::Attribute, Text::Whitespace, Punctuation
        end

        # Range brackets
        rule %r/[\[\{]/, Punctuation
        rule %r/[\]\}]/, Punctuation

        # Parentheses and comma
        rule %r/[(),]/, Punctuation

        # Comparison operators (unbounded range queries: >, <, >=, <=)
        rule %r/>=|<=|>|</, Operator

        # Boost and fuzzy operators: ~, ^
        rule %r/[~^]/, Operator

        # Wildcard operators: *, ?
        rule %r/[*?]/, Operator

        # Required/prohibited operators: +, -
        rule %r/[+\-!]/, Operator

        # Floats before integers
        rule %r/\d+\.\d+/, Num::Float

        # Integers
        rule %r/\d+/, Num::Integer

        # Keywords and identifiers
        rule %r/[a-zA-Z_][a-zA-Z0-9_]*/ do |m|
          if self.class.bool_operators.include?(m[0])
            token Keyword::Pseudo
          elsif self.class.range_keywords.include?(m[0])
            token Keyword
          else
            token Name
          end
        end

        # Catch-all: dots (IP addresses, field values), colons, slashes, and any other character
        rule %r/[^\s]/, Name
      end

      state :double_string do
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
        rule %r/[^"\\]+/, Str::Double
      end

      state :regex_literal do
        rule %r/\\./, Str::Escape
        rule %r(/)  , Str::Regex, :pop!
        rule %r([^/\\]+), Str::Regex
      end
    end
  end
end
