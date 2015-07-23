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
	int column;
	Captures!(string) match;
	int acumulatedPos = 0;
	
	match=matchFirst(source.srcBody, regex(r"\r\n|[\n\r\u2028\u2029]","gmi"));
	
	while(match && acumulatedPos+match.pre.length+match[0].length < position){
		line++;
		acumulatedPos += (match.pre.length+match[0].length);
		match=matchFirst(match.post, regex(r"\r\n|[\n\r\u2028\u2029]","gmi"));
	};	
	//writeln(source.srcBody[0..position]);
	
	column = position - acumulatedPos + (acumulatedPos ? 0 : 1);
	
	return SourceLocation(line, column);
}

