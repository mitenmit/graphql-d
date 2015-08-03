import std.stdio;
import std.regex;
import std.variant;
import std.conv;

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
	//Test recursive class
	RecClass rec = new RecClass("Level 1", new RecClass("Level 2", new RecClass("Level 3")));
	//writeln(rec);
	//rec.showTree();

	//Test how arrays are passed by refference and copied
	string[] stringsArr = ["1", "2", "3"];
	auto stringsCls = new TestArrRef(stringsArr);
	stringsArr[1] = "Changed";
	//writeln(stringsArr);
	//writeln(stringsCls.arr);
	
	Changer cp = new Changer("Initially set parameter of the class");
	//writeln(cp.param);
	chParam1(cp);
	//writeln(cp.param);
	
	Changer[] nodes;
	nodes ~= new Changer("New element");
	//writeln(nodes[0]);
	
	Source src = new Source;
	
	src.srcBody = "{ hello }";
	
	src.srcBody = "query FetchLukeQuery{human(id: \"1000\"){name}}";
	
	//parsercore.Parser p = makeParser(src, ParseOptions(false, false) );
	
	Document d = parse(src, ParseOptions(false, false));
	
	writeln( d.definitions[0].get!(OperationDefinition)().operation );
	writeln( d.definitions[0].get!(OperationDefinition)().name.value );
	
	Field f = d.definitions[0].get!(OperationDefinition)().selectionSet.selections[0].get!(Field)();
	writeln( f.name.value );
	writeln( f.arguments[0].value.kind );
	writeln( f.arguments[0].name.value ~":"~to!string(f.arguments[0].value.get!(StringValue)().value ) );
	writeln( f.selectionSet.selections[0].get!(Field)().name.value );
	
	//Lexer nextToken = lex(src);
	//Token a = nextToken(0);
	
	/*
	Token numToken = readNumber(src, 8, 55);
	writeln(numToken);
	*/
	
	string multiLines =
"{
	{
	User(id=1):
		name,
		location
	}
}";

	/*	
	Captures!(string) match = matchFirst(multiLines, regex(r"\r\n|[\n\r\u2028\u2029]","gmi") );
	//writeln( match.pre.length );
	Source source = new Source;
	source.srcBody = multiLines;
	*/
		
	return 0;
}