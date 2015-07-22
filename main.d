import std.stdio;

import source;
import lexer;


int main()
{
	Source src = new Source;
	
	src.srcBody = "{hello}";
	
	Lexer nextToken = lex(src);
	
	Token a = nextToken(0);
	
	string st = "Hello";
	
	writeln( cast(int)st[0] );
	
	return 0;
}