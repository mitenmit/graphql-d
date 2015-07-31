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
	
	do{
		if( peek(parser, TokenKind.BRACE_L) ){
			definitions ~= parseOperationDefinition(parser);
		}else if( peek(parser, TokenKind.NAME) ){
			if(parser.token.value == "query" || parser.token.value == "mutation"){
				//definitions ~= parseOperationDefinition(parser);
			}else if( parser.token.value == "fragment" ){
				//definitions ~= parseFragmentDefinition(parser);
			} else {
				//throw unexpected(parser);
			}
		} else {
			//throw unexpected(parser);
		}
		
	} while( !skip(parser, TokenKind.EOF) );
	
	return new Document(DOCUMENT, loc(parser, start), definitions);
}

OperationDefinition parseOperationDefinition(Parser parser){
	int start = parser.token.start;
	
	return new OperationDefinition();
}