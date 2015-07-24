import std.typetuple;
import std.typecons;
import std.string;
import std.traits;

import source;

struct Location{
	int start;
	int end;
	Source source;
}

alias Node = TypeTuple!(Name);

// Name

struct Name{
	string kind = "Name";
	Location loc;
	string value;
}

// Document

struct Document(T){
	static if ( staticIndexOf!(T,Definition) != -1 )	
	{		
		string kind = "Document";
		Location loc;
		T[] definitions;
	}else{
		static assert(0, "Type not supported for Document.");
	}	
}

alias Definition = TypeTuple!(OperationDefinition, FragmentDefinition);

struct OperationDefinition{
	string kind = "OperationDefinition";
	Location loc;
	string operation;
	Name name;
	VariableDefinition[] variableDefinitions;
	Direcive[] directives;
	SelectionSet selectionSet;
}

struct VariableDefinition(T, V){
	static if ( staticIndexOf!(T,Type) != -1 && staticIndexOf!(V, Value) != -1)	
	{
		string kind = "VariableDefinition";
		Location loc;
		Variable variable;
		Type type;
		Value defaultValue;
	}else{
		static assert(0, "Type not supported for Document.");
	}
}

struct Variable{
	string kind = "Variable";
	Location loc;
	Name name;
}

struct SelectionSet{
	string kind = "SelectionSet";
	Location loc;
	S[]	selections;
}

alias Selection = TypeTuple!(Field, FragmentSpread, InlineFragment);

struct Field{
	string kind = "Field";
	Location loc;
	Name fldAlias;
	Name name;
	Argument[] arguments;
	Directive[] directives;
	SelectionSet selectionSet;
}

struct Argument(T){
	static if ( staticIndexOf!(T,Dictionary) != -1 )	
	{	
		string kind = "Argument";
		Location loc;
		Name name;
		T value;
	}else{
		static assert(0, "Type not supported for Argument.");
	}	
}

// Fragments

struct FragmentSpread{
	string kind = "FragmentSpread";
	Location loc;
	Name name;
	Directive[] directives;	
}

struct InlineFragment{
	string kind = "InlineFragment";
	Location loc;
	NamedType typeCondition;
	Directive[] directives;
	SelectionSet selectionSet;
}

struct FragmentDefinition{
	string kind = "FragmentDefinition";
	Location loc;
	Name name;
	NamedType typeCondition;
	Directive[] directives;
	SelectionSet selectionSet;	
}

// Values

alias Selection = TypeTuple!(
	Variable,
	IntValue,
	FloatValue,
	StringValue,
	BooleanValue,
	EnumValue,
	ArrayValue,
	ObjectValue
);

/*
alias Dictionary = TypeTuple!(float, int, char);

struct MyType(T){
	static if ( staticIndexOf!(T,Dictionary) != -1 )	
	{		
		T number;
	}else{
		static assert(0, "Type not supported.");
	}
}
*/
