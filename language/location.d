import std.stdio;
import std.regex;

import source;

/**
 * Represents a location in a Source.
 */
 
struct SourceLocation{
	int line;
	int column;
}

/**
 * Takes a Source and a UTF-8 character offset, and returns the corresponding
 * line and column as a SourceLocation.
 */
 
SourceLocation getLocation(Source source, int position){
	int line = 1;
	int column = position+1;
	//string lineRegexp = /\r\n|[\n\r\u2028\u2029]/g;
	RegexMatch!(string) match;

	/*
	while( (match=matchAll(source.srcBody, regex(r"\r\n|[\n\r\u2028\u2029]","gmi")) )<>[] && match.index < position ){		
		line += 1;
		column = position + 1 - (match.index + match[0].length);
	}
	*/
	
	return SourceLocation(line, column);
}

