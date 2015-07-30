import std.stdio;

import source;
import lexer;
import ast;

class Parser{
	Lexer _lexToken;
	Source source;
	ParseOptions options;
	int prevEnd = 0;
	Token token;
	
	this(){}
	
	this(Lexer _pLexToken, Source pSource, ParseOptions pOptions, int pPrevEnd, Token pToken){
		_lexToken = _pLexToken;
		source = pSource;
		options = pOptions;
		prevEnd = pPrevEnd;
		token = pToken;
	}
}

/**
 * Returns the parser object that is used to store state throughout the
 * process of parsing.
 */
Parser makeParser(Source source, ParseOptions options){
	Lexer _lexToken = lex(source);
	return new Parser(
					_lexToken,
					source,
					options,
					0,
					_lexToken(0)
				);
}

/**
 * Configuration options to control parser behavior
 */
struct ParseOptions{
	/**
	 * By default, the parser creates AST nodes that know the location
	 * in the source that they correspond to. This configuration flag
	 * disables that behavior for performance or testing.
	 */
	bool noLocation;
	
	/**
	 * By default, the parser creates AST nodes that contain a reference
	 * to the source that they were created from. This configuration flag
	 * disables that behavior for performance or testing.
	 */
	bool noSource;
}

/**
 * Returns a location object, used to identify the place in
 * the source that created a given parsed object.
 */
 
Location loc(Parser parser, int start){
	if(parser.options.noLocation){
		return Location();
	}
	
	if(parser.options.noSource){
		return Location(start, parser.prevEnd, null );
	}
	
	return Location(start, parser.prevEnd, parser.source);
}

/**
 * Moves the internal parser object to the next lexed token.
 */
void advance(Parser parser){
	int prevEnd = parser.token.end;
	
	parser.prevEnd = prevEnd;
	parser.token = parser._lexToken(prevEnd);
}

/**
 * Determines if the next token is of a given kind
 */
 
bool peek(Parser parser, int kind){
	return parser.token.kind == kind;
}

/**
 * If the next token is of the given kind, return true after advancing
 * the parser. Otherwise, do not change the parser state and return false.
 */
bool skip(Parser parser, int kind){
	bool match = (parser.token.kind==kind);
	if(match){
		advance(parser);
	}
	
	return match;
}

/**
 * If the next token is of the given kind, return that token after advancing
 * the parser. Otherwise, do not change the parser state and return false.
 */
Token expect(Parser parser, int kind){
	Token token = parser.token;
	if(token.kind == kind){
		advance(parser);
		return token;
	}
	
	//throw syntaxError(parser.source, token.start, "Expected "~getTokenKindDesc(kind)~", found "~getTokenDesc(token));
	//assert(0);
	return Token();
}

/**
 * If the next token is a keyword with the given value, return that token after
 * advancing the parser. Otherwise, do not change the parser state and return
 * false.
 */

Token expectKeyword(Parser parser, string value ){
	Token token = parser.token;
	
	if(token.kind == TokenKind.NAME && token.value == value){
		advance(parser);
		return token;
	}
	
	//throw syntaxError(parser.source, token.start, "Expected "~value~", found "~getTokenDesc(token));
	//assert(0);
	return Token();
}

/**
 * Helper export function for creating an error when an unexpected lexed token
 * is encountered.
 */
/*
Error unexpected(Parser parser, Token atToken){
	Token token = atToken || parser.token;
	
	return syntaxError(parser.source, token.start, "Unexpected "~getTokenDesc(token));
}
*/
 
/**
 * Returns a possibly empty list of parse nodes, determined by
 * the parseFn. This list begins with a lex token of openKind
 * and ends with a lex token of closeKind. Advances the parser
 * to the next lex token after the closing token.
 */
T[] any(T)(Parser parser, int openKind, T delegate(Parser) parseFn,int closeKind){
	expect(parser, openKind);
	T[] nodes;
	
	while(!skip(parser, closeKind)){
		nodes ~= parseFn(parser);
	}
	
	return nodes;
} 
 
/**
 * Returns a non-empty list of parse nodes, determined by
 * the parseFn. This list begins with a lex token of openKind
 * and ends with a lex token of closeKind. Advances the parser
 * to the next lex token after the closing token.
 */
T[] many(T)(Parser parser, int openKind, T delegate(Parser) parseFn,int closeKind){
	expect(parser, openKind);
	T[] nodes;
	nodes ~= parseFn(parser);
	
	while(!skip(parser, closeKind)){
		nodes ~= parseFn(parser);
	}
	
	return nodes;
}
