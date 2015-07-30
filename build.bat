::dmd -I%cd%/language main.d
::dmd main.d language/lexer.d language/source.d language/location.d language/ast.d language/kinds.d language/parsercore.d