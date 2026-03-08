# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## Commands

```sh
bundle config set --local path vendor/bundle && bundle install  # Install dependencies
bundle exec rake        # Run the test suite (default task)
bundle exec rake server # Start visual preview server at http://localhost:9292
ruby preview.rb         # Terminal preview of both lexers
ruby preview.rb query   # Terminal preview of query lexer only
ruby preview.rb pipeline # Terminal preview of pipeline lexer only
DEBUG=1 ruby preview.rb query # Print each token and its type
```

To check for error tokens via the preview server:

```sh
curl -s http://localhost:9292 | grep 'class="err"'
```

## Architecture

This gem ships **two separate Rouge lexers** for two structurally different Graylog
languages. They share a gem but have no shared code — each is an independent
`RegexLexer` subclass.

| Lexer class | Tag | File |
| --- | --- | --- |
| `Rouge::Lexers::GraylogQuery` | `graylog-query` | `lib/rouge/lexers/graylog_query.rb` |
| `Rouge::Lexers::GraylogPipeline` | `graylog-pipeline` | `lib/rouge/lexers/graylog_pipeline.rb` |

**Key files:**

- [lib/rouge/lexers/graylog_query.rb](lib/rouge/lexers/graylog_query.rb) — Query lexer implementation
- [lib/rouge/lexer/graylog_query.rb](lib/rouge/lexer/graylog_query.rb) — Query entry point (require-only)
- [lib/rouge/lexers/graylog_pipeline.rb](lib/rouge/lexers/graylog_pipeline.rb) — Pipeline lexer implementation
- [lib/rouge/lexer/graylog_pipeline.rb](lib/rouge/lexer/graylog_pipeline.rb) — Pipeline entry point (require-only)
- [spec/rouge_lexer_graylog_query_spec.rb](spec/rouge_lexer_graylog_query_spec.rb) — Query test suite
- [spec/rouge_lexer_graylog_pipeline_spec.rb](spec/rouge_lexer_graylog_pipeline_spec.rb) — Pipeline test suite
- [spec/demos/graylog_query](spec/demos/graylog_query) — Short query demo
- [spec/demos/graylog_pipeline](spec/demos/graylog_pipeline) — Short pipeline demo
- [spec/visual/samples/graylog_query](spec/visual/samples/graylog_query) — Comprehensive query sample
- [spec/visual/samples/graylog_pipeline](spec/visual/samples/graylog_pipeline) — Comprehensive pipeline sample

**Lexer structure:** Each lexer uses class-level `Set` caches for keyword
classification. The `:root` state matches tokens in priority order; a catch-all
rule does set-membership lookups to assign the correct token type.

## Graylog references

Use *ONLY* official documentation, *NOT* from memory, training, or inference.

### Documentation

**MANDATORY: Before writing or modifying either lexer, you MUST fetch and read
every URL in this list.** This is not background reading — it is a required
prerequisite step. Fetch each page, extract the keywords or function names, and
verify them against the lexer before declaring any work complete.

#### Search query documentation

- Writing Search Queries <https://go2docs.graylog.org/current/making_sense_of_your_log_data/writing_search_queries.html>

#### Pipeline documentation

- Pipelines <https://go2docs.graylog.org/current/making_sense_of_your_log_data/pipelines.htm>
- Pipeline Rule Logic <https://go2docs.graylog.org/current/making_sense_of_your_log_data/rules.html>
- Pipeline functions <https://go2docs.graylog.org/current/making_sense_of_your_log_data/functions.html>
- Pipeline function reference <https://go2docs.graylog.org/current/making_sense_of_your_log_data/functions_index.html>

## Rouge references

- Lexer development guide: <https://github.com/rouge-ruby/rouge/blob/main/docs/LexerDevelopment.md>
- Existing lexers for reference: <https://github.com/rouge-ruby/rouge/tree/main/lib/rouge/lexers>
- JSON lexer (simple example): <https://github.com/rouge-ruby/rouge/blob/main/lib/rouge/lexers/json.rb>
- SQL lexer (keyword-heavy analog): <https://github.com/rouge-ruby/rouge/blob/main/lib/rouge/lexers/sql.rb>
- Token types: <https://github.com/rouge-ruby/rouge/blob/main/lib/rouge/token.rb>

## Verification workflow (MANDATORY — do this BEFORE adding anything)

Before writing or modifying either lexer, fetch **every URL in the documentation
list** above. Do not begin implementation until all pages have been read.

Before adding ANY individual keyword, function, or syntax element:

1. **Fetch the relevant documentation page** using the WebFetch tool or curl.
2. **Extract and confirm** the element exists in the fetched content. Do not rely
   on training data, memory, or assumptions about what "should" exist.
3. **Only add** elements that appear in the fetched content. **Only remove**
   elements confirmed absent.

### What NOT to do

- **Do NOT add keywords or syntax from training data or memory.** Every addition
  must be traced to a specific URL from the reference list in this file.
- **Do NOT use preview/beta features** unless explicitly asked. Only add GA
  (generally available) features.
- **Do NOT fabricate or modify reference URLs.** Use ONLY the exact URLs listed
  in this file. If a URL doesn't work, say so — do not guess an alternative.
- **Do NOT assume a function exists because a similar one does.**
- **Do NOT mix query syntax into the pipeline lexer or vice versa.**

### Self-verification

After making changes, verify correctness by **re-fetching the source documentation**
and confirming every added element appears in the fetched HTML. Do not verify by
re-reading your own changes.

### Constraints (applies to all work)

- **No hallucinated syntax.** Every keyword, function, operator, and language
  construct in the lexer must come from the official documentation listed above.
- **Follow Rouge conventions exactly.** Study existing lexers (especially JSON and
  SQL) for patterns. Don't invent novel approaches.
- **The Error token count is the ground truth.** The visual preview server is the
  authoritative test. `bundle exec rake` passing is necessary but not sufficient —
  you must also have zero `class="err"` spans.
- **Iterate until clean.** Do not declare the task complete until both
  `bundle exec rake` passes AND the Error token count is zero for both demos and
  both visual samples.
- **Update the visual sample** whenever new tokens are added to a lexer, so every
  token type has coverage.

The markdownlint configuration in [.vscode/settings.json](.vscode/settings.json)
sets `MD024` to `siblings_only: true`, allowing repeated heading text under
different parent headings (e.g. `### Added` appearing under multiple version
sections in the changelog).

## README conventions

The Jekyll / GitHub Pages section of [README.md](README.md) **must** include a
`Gemfile` example showing the gem added inside `group :jekyll_plugins do … end`
**before** the fenced code block examples. Do not omit this example or move it
after the code blocks.

## Changelog

The changelog ([CHANGELOG.md](CHANGELOG.md)) follows the
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format and
[Semantic Versioning](https://semver.org/spec/v2.0.0.html). When updating the
changelog:

- Use `## [version] - YYYY-MM-DD` for release headings
- Use `### Added`, `### Changed`, `### Removed` as second-level section headings
- Use `#### Category name` as optional third-level headings within a section
- Ensure blank lines surround all headings to satisfy markdownlint
