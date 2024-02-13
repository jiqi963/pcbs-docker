e = 'error'
w = 'warn'
i = 'ignore'

module.exports =
  arrow_spacing:
    level: e
  braces_spacing:
    level: e
    spaces: 0
  colon_assignment_spacing:
    level: e
    spacing:
      left: 0
      right: 1
  empty_constructor_needs_parens:
    level: e
  ensure_comprehensions:
    level: e
  eol_last:
    level: e
  indentation:
    level: e
    value: 2
  line_endings:
    level: e
    value: 'unix'
  max_line_length:
    level: w
    value: 100
  newlines_after_classes:
    level: e
    value: 1
  no_backticks:
    level: i
  no_empty_functions:
    level: e
  no_empty_param_list:
    level: i
  no_implicit_braces:
    level: i
  no_stand_alone_at:
    level: e
  no_throwing_strings:
    level: e
  no_trailing_semicolons:
    level: e
  no_trailing_whitespace:
    level: e
  no_unnecessary_double_quotes:
    level: w
  no_unnecessary_fat_arrows:
    level: w
  prefer_english_operator:
    level: w
  space_operators:
    level: e
  spacing_after_comma:
    level: e
