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
	
	int position = positionAfterWhitespace(sBody, fromPosition);
	int code = cast(int)sBody[position];
	
	if (position >= bodyLength) {
		return makeToken(TokenKind.EOF, position, position, null);
	}
	
	switch(code){
		 // !
		case 33: return makeToken(TokenKind.BANG, position, position + 1, null);
		// $
		case 36: return makeToken(TokenKind.DOLLAR, position, position + 1, null);
		// (
		case 40: return makeToken(TokenKind.PAREN_L, position, position + 1, null);
		// )
		case 41: return makeToken(TokenKind.PAREN_R, position, position + 1, null);
		// .
		case 46:
			if (cast(int)sBody[position+1] == 46 &&
			  cast(int)sBody[position+2] == 46) {
			return makeToken(TokenKind.SPREAD, position, position + 3, null);
			}
			break;
		// :
		case 58: return makeToken(TokenKind.COLON, position, position + 1, null);
		// =
		case 61: return makeToken(TokenKind.EQUALS, position, position + 1, null);
		// @
		case 64: return makeToken(TokenKind.AT, position, position + 1, null);
		// [
		case 91: return makeToken(TokenKind.BRACKET_L, position, position + 1, null);
		// ]
		case 93: return makeToken(TokenKind.BRACKET_R, position, position + 1, null);
		// {
		case 123: return makeToken(TokenKind.BRACE_L, position, position + 1, null);
		// |
		case 124: return makeToken(TokenKind.PIPE, position, position + 1, null);
		// }
		case 125: return makeToken(TokenKind.BRACE_R, position, position + 1, null);
		// A-Z
		case 65: case 66: case 67: case 68: case 69: case 70: case 71: case 72:
		case 73: case 74: case 75: case 76: case 77: case 78: case 79: case 80:
		case 81: case 82: case 83: case 84: case 85: case 86: case 87: case 88:
		case 89: case 90:
		// _
		case 95:
		// a-z
		case 97: case 98: case 99: case 100: case 101: case 102: case 103: case 104:
		case 105: case 106: case 107: case 108: case 109: case 110: case 111:
		case 112: case 113: case 114: case 115: case 116: case 117: case 118:
		case 119: case 120: case 121: case 122:
		  return readName(source, position);
		// -
		case 45:
		// 0-9
		case 48: case 49: case 50: case 51: case 52:
		case 53: case 54: case 55: case 56: case 57:
		  return readNumber(source, position, code);
		// "
		case 34: return readString(source, position);
		default:
			break;
	}
	
	//trhow syntaxError(source, position, "Unexpected character '"~cast(char)code~"'");
	
	//Token t = {1,1,1, "{"}; //Temporary initiaisation
	return Token();
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
		  
		  code = cast(int)sBody[position];
		  
		  while (
			position < bodyLength &&
			code &&
			code != 10 && code != 13 && code != 0x2028 && code != 0x2029
		  ) {
			++position;
			code = cast(int)sBody[position];
		  }
		} else {
		  break;
		}
	}
	
	return 0;
 }
 
/**
 * Reads a number token from the source file, either a float
 * or an int depending on whether a decimal point appears.
 *
 * Int:   -?(0|[1-9][0-9]*)
 * Float: -?(0|[1-9][0-9]*)(\.[0-9]+)?((E|e)(+|-)?[0-9]+)?
 */

Token readNumber(Source source, int start, int firstCode)
{
	int code = firstCode;
	string sBody = source.srcBody;
	int position = start;
	bool isFloat = false;
	
	if(code == 45){ // -
		code = cast(int)sBody[++position];
	}
	
	if(code == 48){ // 0
		code = cast(int)sBody[++position];
	}else if(code >= 49 && code <= 57){ //1 - 9
		do{
			code = cast(int)sBody[++position];
		}while(code >= 48 && code <= 57); // 0 - 9
	} else {
		//syntax error
		//throw sytaxError(source, position, "Invalid number");
	}
	
	if(code == 46){	// .
		isFloat = true;
		
		code = cast(int)sBody[++position];
		if(code >= 48 && code <= 57){ //0 - 9
			do{
				code = cast(int)sBody[++position];
			}while(code >= 48 && code <= 57); // 0 - 9
		}else{
			//syntax error
			//throw sytaxError(source, position, "Invalid number");
		}
	}
	
	if(code == 69 || code == 101){ // E e
		isFloat = true;
		
		code = cast(int)sBody[++position];
		if(code == 43 || code == 45){ // + -
			code = cast(int)sBody[++position];
		}
		if(code >= 48 && code <= 57){ //0 - 9
			do{
				code = cast(int)sBody[++position];
			}while(code >= 48 && code <= 57); // 0 - 9
		}else{
			//syntax error
			//throw sytaxError(source, position, "Invalid number");
		}
	}
	
	return makeToken(
		isFloat ? TokenKind.FLOAT : TokenKind.INT,
		start,
		position,
		sBody[start..position]
	);
}

/**
 * Reads a string token from the source file.
 *
 * "([^"\\\u000A\u000D\u2028\u2029]|(\\(u[0-9a-fA-F]{4}|["\\/bfnrt])))*"
 */
 Token readString(Source source, int start)
 {
	string sBody = source.srcBody;
	int position = start + 1;
	int chunkStart = position;
	int code;
	string value = "";
	
	//TODO: ...
	
	while(
		position < sBody.length &&
		(code = cast(int)sBody[position])<>0 &&
		code != 34 &&
		code != 10 && code != 13 && code != 0x2028 && code != 0x2029
	){
		++position;
		if(code == 92){ // \
			value ~= sBody[chunkStart..(position-1)];
			code = cast(int)sBody[position];
			
			switch (code){
				case 34: value~="\""; break;
				case 47: value~="/"; break;
				case 92: value~="\\"; break;
				case 98: value~="\b"; break;
				case 102: value~="\f"; break;
				case 110: value~="\n"; break;
				case 114: value~="\r"; break;
				case 116: value~="\t"; break;
				case 117:
					int charCode = uniCharCode(
						sBody[position+1],
						sBody[position+2],
						sBody[position+3],
						sBody[position+4],
					);
					
					if(charCode < 0){
						//throw syntaxError();
					}
					value ~= cast(char)charCode;
					position += 4;
					break;
				default:
					//throw syntaxError();
			}
			
			++position;
			chunkStart = position;
		}
	}
	
	if(code != 34){
		//throw syntaxError(source, position, "Unterminated string");
	}
	
	value ~= sBody[chunkStart..position];
	return makeToken(TokenKind.STRING, start, position+1, value);
 }
 
/**
 * Converts four hexidecimal chars to the integer that the
 * string represents. For example, uniCharCode('0','0','0','f')
 * will return 15, and uniCharCode('0','0','f','f') returns 255.
 *
 * Returns a negative number on error, if a char was invalid.
 *
 * This is implemented by noting that char2hex() returns -1 on error,
 * which means the result of ORing the char2hex() will also be negative.
 */

int uniCharCode(char a, char b, char c, char d){
	return char2hex(a)<<12 | char2hex(b)<<8 | char2hex(c)<<4 | char2hex(d);
}

/**
 * Converts a hex character to its integer value.
 * '0' becomes 0, '9' becomes 9
 * 'A' becomes 10, 'F' becomes 15
 * 'a' becomes 10, 'f' becomes 15
 *
 * Returns -1 on error.
 */
 
int char2hex(char a){
	return (
		a >= 48 && a <= 57 ? a - 48 : // 0-9
		a >= 65 && a <= 70 ? a - 55 : // A-F
		a >= 97 && a <= 102 ? a - 87 : // a-f
		-1
	);
}

/**
 * Reads an alphanumeric + underscore name from the source.
 *
 * [_A-Za-z][_0-9A-Za-z]*
 */
 
Token readName(Source source, int position)
{
	string sBody = source.srcBody;
	int bodyLength = sBody.length;
	int end = position+1;
	int code;
	
	while(
		end != bodyLength &&
		(code = cast(int)sBody[end])<>0 &&
		(
			code == 95 ||
			code >= 48 && code <= 57 || // 0-9
			code >= 65 && code <= 90 ||	// A-Z
			code >= 97 && code <= 122 	// a-z
		)
		
	){
		++end;
	}
	
	return makeToken(TokenKind.NAME, position, end, sBody[position..end]);
}

 


