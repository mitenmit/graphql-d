import std.stdio;
import std.regex;
import std.variant;

import source;
import lexer;
import location;
import kinds;
import ast;
import parsercore;
import parser;

//import jsvar;

class Changer{
	string param;
	
	this(){}
	this(string p){param = p;}
}

void chParam(Changer c){
	c.param = "Changed parameter of the class";
}

void chParam1(Changer c){
	chParam(c);
}

class TestArrRef{
	string[] arr;
	
	this(){}
	
	this(string[] arr){
		this.arr = arr.dup;
		arr=["changed"];
	}
	
	override string toString(){
		string result="[";
		
		foreach(a; arr){
			result~=a~",";
		}
		result ~= "]";
		
		return result;
	}
}

class RecClass{
	string name;
	
	RecClass node;
	
	this(){}
	
	this(string name){
		this.name = name;
	}
	
	this(RecClass node){
		this.node = node;
	}
	
	this(string name, RecClass node){
		this.name = name;
		this.node = node;
	}
	
	override string toString(){
		return name;
	}
	
	void showTree()
	{
		RecClass res = this;
		int tab = 0;
		
		while(res !is null){
			for(int t=0;t<tab; t++)
				write("\t");
			writeln(res.name);
			tab++;
			res = res.node;
		}
	}
}

int main()
{
	RecClass rec = new RecClass("Level 1", new RecClass("Level 2", new RecClass("Level 3")));
	//writeln(rec);
	rec.showTree();

	string[] stringsArr = ["1", "2", "3"];
	auto stringsCls = new TestArrRef(stringsArr);
	stringsArr[1] = "Changed";
	writeln(stringsArr);
	writeln(stringsCls.arr);
	
	Changer cp = new Changer("Initially set parameter of the class");
	writeln(cp.param);
	chParam1(cp);
	writeln(cp.param);
	
	Changer[] nodes;
	nodes ~= new Changer("New element");
	//writeln(nodes[0]);
	
	Source src = new Source;
	
	src.srcBody = "{hello: 753}";
	
	parsercore.Parser p = makeParser(src, ParseOptions(false, false) );
	
	
	Lexer nextToken = lex(src);
	Token a = nextToken(0);
	
	Token numToken = readNumber(src, 8, 55);
	writeln(numToken);
	
	/*
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
	*/
	
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