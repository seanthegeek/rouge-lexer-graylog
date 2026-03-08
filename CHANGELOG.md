# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-03-08

### Added

- Initial release of the `rouge-lexer-graylog` gem

- `Rouge::Lexers::GraylogQuery` lexer with tag `graylog-query` and alias `graylog-search`,
  MIME type `text/x-graylog-query`

- `Rouge::Lexers::GraylogPipeline` lexer with tag `graylog-pipeline` and aliases
  `graylog-rule`, `graylog-rules`, MIME type `text/x-graylog-pipeline`

- Auto-detection heuristics for each lexer based on distinctive syntax patterns

- Token classification for boolean operators, field names, magic fields, strings,
  numeric literals, ranges, wildcards, pipeline functions, comments, and all language keywords

[0.1.0]: https://github.com/seanthegeek/rouge-lexer-graylog/releases/tag/v0.1.0
