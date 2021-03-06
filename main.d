import std.stdio;
import std.regex;
import std.variant;

import source;
import lexer;
import location;
import kinds;
import ast;
import parsercore;

//import jsvar;

class Changer{
	string param;
	
	this(){}
	this(string p){param = p;}
}

void chParam(Changer c){
	c.param = "Changed parameter of the struct";
}

void chParam1(Changer c){
	chParam(c);
}

int main()
{
	alias Atom = Algebraic!(string, int);
	Atom[] atom;
	
	writeln(atom.capacity);
	
	atom ~= Atom(5);
	writeln("Atom: ", atom);
	//atom ~= Atom("Test");
	//atom[1] = "Test";
	//writeln("Atom: ", atom[1]);
	writeln(atom.length);
	
	Changer cp = new Changer("tt");
	//cp.param = "Initially set parameter of the struct";

	writeln(cp.param);
	chParam1(cp);
	writeln(cp.param);
	
	Changer[] nodes;
	nodes ~= new Changer("New element");
	//writeln(nodes[0].param);
	
	Source src = new Source;
	
	src.srcBody = "{hello: 753}";
	
	parsercore.Parser p = makeParser(src, ParseOptions(false, false) );
	
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
	
	/*
	for(int i=0; i<40; i++)
		writeln(i,": ", getLocation(source, i) );
	*/
	
	return 0;
}