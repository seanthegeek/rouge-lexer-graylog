# rouge-lexer-graylog

A [Rouge](https://github.com/rouge-ruby/rouge) plugin providing syntax highlighting
for [Graylog](https://graylog.org/) search queries and pipeline rules.

## Lexers

### `graylog-query` — Graylog Search Query

Highlights Graylog search query syntax including:

- Boolean operators: `AND`, `OR`, `NOT`
- Range keyword: `TO`
- Field names: `field:value`
- Magic fields: `_exists_`, `_missing_`
- Wildcards: `*`, `?`
- Fuzzy / boost operators: `~`, `^`
- Range brackets: `[…]`, `{…}`
- Comparison operators: `>`, `<`, `>=`, `<=`
- Quoted phrase strings
- Regular expression literals: `/pattern/`
- Integer and float literals

**Tag:** `graylog-query`
**Alias:** `graylog-search`
**MIME type:** `text/x-graylog-query`

### `graylog-pipeline` — Graylog Pipeline Rule

Highlights Graylog pipeline rule syntax including:

- Block structure keywords: `rule`, `when`, `then`, `end`, `pipeline`, `stage`, `match`
- Declaration keyword: `let`
- Boolean / null constants: `true`, `false`, `null`
- Boolean operator keywords: `AND`, `OR`, `NOT`
- All 152 built-in pipeline functions
- Magic variables: `$message`, `$pipeline`, `$stage`
- Line comments: `//`
- Double-quoted and single-quoted strings
- Arithmetic and comparison operators
- Integer and float literals

**Tag:** `graylog-pipeline`
**Aliases:** `graylog-rule`, `graylog-rules`
**MIME type:** `text/x-graylog-pipeline`

## Installation

Add to your `Gemfile`:

```ruby
gem 'rouge-lexer-graylog'
```

Or install directly:

```sh
gem install rouge-lexer-graylog
```

## Usage

### Ruby

```ruby
require 'rouge'
require 'rouge/lexer/graylog_query'
require 'rouge/lexer/graylog_pipeline'

# Highlight a Graylog search query
lexer     = Rouge::Lexers::GraylogQuery.new
formatter = Rouge::Formatters::HTML.new
source    = 'source:ssh AND level:error AND NOT _exists_:user_id'
puts formatter.format(lexer.lex(source))

# Highlight a Graylog pipeline rule
lexer  = Rouge::Lexers::GraylogPipeline.new
source = <<~RULE
  rule "tag ssh errors"
  when
    has_field("source") AND to_string($message.source) == "sshd"
  then
    set_field("tag", "ssh-error");
  end
RULE
puts formatter.format(lexer.lex(source))
```

### Jekyll / GitHub Pages

Rouge is included in Jekyll. Add the gem to your site's `Gemfile` inside the
`:jekyll_plugins` group so Jekyll loads it automatically:

```ruby
group :jekyll_plugins do
  gem 'rouge-lexer-graylog'
end
```

Then run `bundle install`. Reference the lexer by tag in fenced code blocks:

~~~markdown
```graylog-query
source:ssh AND level:error AND NOT _exists_:user_id
```
~~~

~~~markdown
```graylog-pipeline
rule "tag ssh errors"
when
  has_field("source") AND to_string($message.source) == "sshd"
then
  set_field("tag", "ssh-error");
end
```
~~~

### Colors

The lexer tells Rouge how to identify tokens. Rouge wraps each token in a `span` tag
with a `class` related to that token type. If you want to change how the tokens are
highlighted, change themes or add custom CSS.

## Development

```sh
bundle config set --local path vendor/bundle
bundle install
bundle exec rake          # Run test suite
bundle exec rake server   # Start visual preview at http://localhost:9292
ruby preview.rb           # Terminal preview of both lexers
ruby preview.rb query     # Terminal preview of query lexer only
ruby preview.rb pipeline  # Terminal preview of pipeline lexer only
DEBUG=1 ruby preview.rb   # Print each token and its type
```

## License

MIT License. See [LICENSE](LICENSE) for details.

Copyright (c) 2026 Sean Whalen
