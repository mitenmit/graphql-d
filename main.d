import std.stdio;
import std.regex;

import source;
import lexer;

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
		(code = cast(int)txt[pos])<>0
	){
		++pos;
		writeln(cast(char)code);
	}
	
	RegexMatch!(string) match = matchAll("The Quick Brown Fox Jumps Over The Lazy Dog", regex(r"quick\s(brown).+?(jumps)","gmi"));
	writeln(match);
	
	//string st = "Hello";
	//writeln( cast(int)st[0] );
	
	return 0;
}