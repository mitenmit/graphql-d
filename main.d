import std.stdio;
import std.regex;

import source;
import lexer;
import location;

int main()
{
	Source src = new Source;
	
	src.srcBody = "{hello: 753}";
	
	Lexer nextToken = lex(src);
	
	Token a = nextToken(0);
	
	Token numToken = readNumber(src, 8, 55);
	writeln(numToken);
	
	writeln(cast(char)72);
	
	string txt = "This is some text";
	int txtLen = txt.length;
	int code;
	int pos = 0;
	
	while(
		pos!=txtLen &&
		(code = cast(int)txt[pos])!=0
	){
		++pos;
		writeln(cast(char)code);
	}
	
	string multiLines =
"{
	{
	User(id=1):
		name,
		location
	}
}";
		
	Captures!(string) match = matchFirst(multiLines, regex(r"\r\n|[\n\r\u2028\u2029]","gmi") );
	//writeln( match.pre.length );
	Source source = new Source;
	source.srcBody = multiLines;
	
	for(int i=0; i<40; i++)
		writeln(i,": ", getLocation(source, i) );
	
	return 0;
}