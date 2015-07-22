module lexer;

import std.stdio;

import source;

struct Token{
	int kind;
	int start;
	int end;
	
	string value;
}


alias Token delegate(int) Lexer;

Lexer lex(Source source){
	int prevPosition = 0;
	
	Token nextToken(int resetPosition){
		Token token;
		
		token = readToken(source, resetPosition ? resetPosition : prevPosition);
		prevPosition = token.end;
		return token;
	}
	
	return &nextToken;
}

enum TokenKind {
	EOF		= 1,
	BANG 	= 2,
	DOLLAR	= 3,
	PAREN_L	= 4,
	PAREN_R	= 5,
	SPREAD	= 6,
	COLON	= 7,
	EQUALS	= 8,
	AT		= 9,
	BRACKET_L	= 10,
	BRACKET_R	= 11,
	BRACE_L	= 12,
	PIPE	= 13,
	BRACE_R	= 14,
	NAME	= 15,
	VARIABLE= 16,
	INT		= 17,
	FLOAT	= 18,
	STRING	= 19,
};

string tokenDescription[TokenKind.max + 1] = [ 	
	TokenKind.EOF 		: "EOF",
	TokenKind.BANG 		: "!",
	TokenKind.DOLLAR 	: "$",
	TokenKind.PAREN_L	: "(",
	TokenKind.PAREN_R	: ")",
	TokenKind.SPREAD	: "...",
	TokenKind.COLON		: ":",
	TokenKind.EQUALS	: "=",
	TokenKind.AT		: "@",
	TokenKind.BRACKET_L	: "[",
	TokenKind.BRACKET_R	: "]",
	TokenKind.BRACE_L	: "{",
	TokenKind.PIPE		: "|",
	TokenKind.BRACE_R	: "}",
	TokenKind.NAME		: "Name",
	TokenKind.VARIABLE	: "Variable",
	TokenKind.INT		: "Int",
	TokenKind.FLOAT		: "Float",
	TokenKind.STRING	: "String",
];

/**
 * A helper function to describe a token as a string for debugging
 */
 
 string getTokenDesc(Token token){
	return token.value && token.value.length>0 ? getTokenKindDesc(token.kind)~" "~token.value : getTokenKindDesc(token.kind); 
 }
 
/**
 * A helper function to describe a token kind as a string for debugging
 */
 
 string getTokenKindDesc(int kind){
	return tokenDescription[kind];
 }
 
/**
 * Helper function for constructing the Token object.
 */
 
Token makeToken(int kind, int start, int end, string value)
{
	Token res = {kind, start, end, value};
	return res;
}

/**
 * Gets the next token from the source starting at the given position.
 *
 * This skips over whitespace and comments until it finds the next lexable
 * token, then lexes punctuators immediately or calls the appropriate helper
 * fucntion for more complicated tokens.
 */
 
Token readToken(Source source, int fromPosition)
{
	string sBody = source.srcBody;
	int bodyLength = sBody.length;
	
	//TO DO: ...
	
	Token t = {1,1,1, "{"}; //Temporary initiaisation
	return t;
}

/**
 * Reads from body starting at startPosition until it finds a non-whitespace
 * or commented character, then returns the position of that character for
 * lexing.
 */
 
 int positionAfterWhitespace(string sBody, int startPosition)
 {
	int bodyLength = sBody.length;
	int position = startPosition;
	
	while(position<bodyLength){
		int code = cast(int)sBody[position];
		
		// Skip whitespace
		if (
		  code == 32 || // space
		  code == 44 || // comma
		  code == 160 || // '\xa0'
		  code == 0x2028 || // line separator
		  code == 0x2029 || // paragraph separator
		  code > 8 && code < 14 // whitespace
		) {
		  ++position;
		// Skip comments
		} else if (code == 35) { // #
		  ++position;
		  while (
			position < bodyLength &&
			//(code == cast(int)sBody[position]) &&
			code != 10 && code != 13 && code != 0x2028 && code != 0x2029
		  ) {
			++position;
		  }
		} else {
		  break;
		}
	}
	
	return 0;
 }

