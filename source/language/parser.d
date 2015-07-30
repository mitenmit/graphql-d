import std.stdio;

import source;
import lexer;
import ast;
import kinds;
import parsercore;

/**
 * Given a GraphQL source, parses it into a Document.
 * Throws GraphQLError if a syntax error is encountered.
 */

Document parse(Source source, ParseOptions options){
	Parser parser = makeParser(source, options);
	return parseDocument(parser);
}


/**
 * Converts a name lex token into a name parse node.
 */
Name parseName(Parser parser){
	Token token = expect(parser, TokenKind.NAME);
	return new Name(NAME, loc(parser, token.start), token.value);
}

// Implements the parsing rules in the Document section.

Document parseDocument(Parser parser){
	int start = parser.token.start;
	Definition[] definitions;
	
	
	
	return new Document(DOCUMENT, loc(parser, start), definitions);
}