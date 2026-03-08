# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class GraylogPipeline < RegexLexer
      title 'Graylog Pipeline'
      desc 'Graylog pipeline rule syntax'
      tag 'graylog-pipeline'
      aliases 'graylog-rule', 'graylog-rules'
      mimetypes 'text/x-graylog-pipeline'

      # Block structure keywords from Graylog pipeline rules documentation
      def self.keywords
        @keywords ||= Set.new %w(rule when then end pipeline stage match)
      end

      # Declaration keywords from Graylog pipeline rules documentation
      def self.keywords_declaration
        @keywords_declaration ||= Set.new %w(let)
      end

      # Boolean / null constants
      def self.keywords_constant
        @keywords_constant ||= Set.new %w(true false null)
      end

      # Boolean operator keywords from Graylog pipeline rules documentation
      def self.keywords_pseudo
        @keywords_pseudo ||= Set.new %w(AND OR NOT)
      end

      # All built-in functions from Graylog pipeline functions index documentation
      def self.functions
        @functions ||= Set.new %w(
          abbreviate
          abusech_ransom_lookup_domain
          abusech_ransom_lookup_ip
          add_asset_categories
          anonymize_ip
          array_contains
          array_remove
          base16_decode
          base16_encode
          base32_decode
          base32_encode
          base32human_decode
          base32human_encode
          base64_decode
          base64_encode
          base64url_decode
          base64url_encode
          capitalize
          cidr_match
          clone_message
          concat
          contains
          crc32
          crc32c
          create_message
          csv_to_map
          days
          debug
          drop_message
          ends_with
          expand_syslog_priority
          expand_syslog_priority_as_string
          first_non_null
          flatten_json
          flex_parse_date
          format_date
          from_forwarder_input
          from_input
          get_field
          grok
          grok_exists
          has_field
          hex_to_decimal_byte_list
          hours
          in_private_net
          is_bool
          is_collection
          is_date
          is_double
          is_ip
          is_json
          is_list
          is_long
          is_map
          is_not_null
          is_null
          is_number
          is_period
          is_string
          is_url
          join
          key_value
          length
          list_count
          list_get
          lookup
          lookup_add_string_list
          lookup_all
          lookup_assign_ttl
          lookup_clear_key
          lookup_has_value
          lookup_remove_string_list
          lookup_set_string_list
          lookup_set_value
          lookup_string_list
          lookup_string_list_contains
          lookup_value
          lowercase
          machine_asset_lookup
          machine_asset_update
          map_copy
          map_get
          map_remove
          map_set
          md5
          metric_counter_inc
          millis
          minutes
          months
          multi_grok
          murmur3_128
          murmur3_32
          normalize_fields
          now
          otx_lookup_domain
          otx_lookup_ip
          parse_cef
          parse_date
          parse_json
          parse_unix_milliseconds
          period
          regex
          regex_replace
          remove_asset_categories
          remove_field
          remove_from_stream
          remove_multiple_fields
          remove_single_field
          remove_string_fields_by_value
          rename_field
          replace
          route_to_stream
          seconds
          select_jsonpath
          set_associated_assets
          set_field
          set_fields
          sha1
          sha256
          sha512
          spamhaus_lookup_ip
          split
          starts_with
          string_array_add
          string_entropy
          substring
          swapcase
          syslog_facility
          syslog_level
          threat_intel_lookup_domain
          threat_intel_lookup_ip
          to_bool
          to_date
          to_double
          to_ip
          to_long
          to_map
          to_string
          to_url
          tor_lookup
          traffic_accounting_size
          uncapitalize
          uppercase
          urldecode
          urlencode
          user_asset_lookup
          watchlist_add
          watchlist_contains
          watchlist_remove
          weeks
          whois_lookup_ip
          years
        )
      end

      def self.detect?(text)
        return true if text =~ /\brule\s+"[^"]+"/
        return true if text =~ /\bwhen\b.*\bthen\b/m
        return true if text =~ /\bpipeline\s+"[^"]+"/
        false
      end

      state :root do
        rule %r/\s+/, Text::Whitespace

        # Line comments: //
        rule %r(//.*$), Comment::Single

        # Double-quoted strings
        rule %r/"/, Str::Double, :double_string

        # Single-quoted strings
        rule %r/'/, Str::Single, :single_string

        # Magic variables: $message, $pipeline, $stage
        rule %r/\$[a-zA-Z_][a-zA-Z0-9_]*/, Name::Variable::Magic

        # Floats before integers
        rule %r/\d+\.\d+/, Num::Float

        # Integers
        rule %r/\d+/, Num::Integer

        # Identifiers and keywords
        rule %r/[a-zA-Z_][a-zA-Z0-9_]*/ do |m|
          if self.class.keywords.include?(m[0])
            token Keyword
          elsif self.class.keywords_declaration.include?(m[0])
            token Keyword::Declaration
          elsif self.class.keywords_constant.include?(m[0])
            token Keyword::Constant
          elsif self.class.keywords_pseudo.include?(m[0])
            token Keyword::Pseudo
          elsif self.class.functions.include?(m[0])
            token Name::Builtin
          else
            token Name
          end
        end

        # Arithmetic and comparison operators
        rule %r/==|!=|<=|>=|&&|\|\||[+\-*\/<>=!]/, Operator

        # Brackets, commas, semicolons, colons, dots, parentheses
        rule %r/[;:()\[\]{},.]/, Punctuation

        # Catch-all for any remaining characters
        rule %r/./, Text
      end

      state :double_string do
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
        rule %r/[^"\\]+/, Str::Double
      end

      state :single_string do
        rule %r/\\./, Str::Escape
        rule %r/'/, Str::Single, :pop!
        rule %r/[^'\\]+/, Str::Single
      end
    end
  end
end
