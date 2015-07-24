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

alias Node = TypeTuple!(
	Name,
	Document,
	OperationDefinition,
	VariableDefinition,
	Variable,
	SelectionSet,
	Field,
	Argument,
	FragmentSpread,
	InlineFragment,
	FragmentDefinition,
	IntValue,
	FloatValue,
	StringValue,
	BooleanValue,
	EnumValue,
	ArrayValue,
	ObjectValue,
	ObjectField,
	Directive,
	ListType,
	NonNullType
);

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


struct OperationDefinition(VDT, VDV, D, SS){
	string kind = "OperationDefinition";
	Location loc;
	string operation;
	Name name;
	VariableDefinition!(VDT, VDV)[] variableDefinitions;
	Directive!(D)[] directives;
	SelectionSet!(SS) selectionSet;
}


struct VariableDefinition(T, V){
	static if ( staticIndexOf!(T,Type) != -1 && staticIndexOf!(V, Value) != -1)	
	{
		string kind = "VariableDefinition";
		Location loc;
		Variable variable;
		T type;
		V defaultValue;
	}else{
		static assert(0, "Type not supported for VariableDefinition.");
	}
}

struct Variable{
	string kind = "Variable";
	Location loc;
	Name name;
}

struct SelectionSet(T){
	static if ( staticIndexOf!(T,Selection) != -1 )	
	{
		string kind = "SelectionSet";
		Location loc;
		T[]	selections;
	}else{
		static assert(0, "Type not supported for SelectionSet.");
	}	
}

alias Selection = TypeTuple!(Field, FragmentSpread, InlineFragment);


struct Field(A, D, SS){
	string kind = "Field";
	Location loc;
	Name fldAlias;
	Name name;
	Argument!(A)[] arguments;
	Directive!(D)[] directives;
	SelectionSet!(SS) selectionSet;
}


struct Argument(T){
	static if ( staticIndexOf!(T,Value) != -1 )	
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

struct FragmentSpread(D){
	string kind = "FragmentSpread";
	Location loc;
	Name name;
	Directive!(D)[] directives;	
}

struct InlineFragment(SS){
	string kind = "InlineFragment";
	Location loc;
	NamedType typeCondition;
	Directive[] directives;
	SelectionSet!(SS) selectionSet;
}

struct FragmentDefinition(SS){
	string kind = "FragmentDefinition";
	Location loc;
	Name name;
	NamedType typeCondition;
	Directive[] directives;
	SelectionSet!(SS) selectionSet;	
}

// Values

alias Value = TypeTuple!(
	Variable,
	IntValue,
	FloatValue,
	StringValue,
	BooleanValue,
	EnumValue,
	ArrayValue,
	ObjectValue
);

struct IntValue{
	string kind = "IntValue";
	Location loc;
	string value;
}

struct FloatValue{
	string kind = "FloatValue";
	Location loc;
	string value;
}

struct StringValue{
	string kind = "StringValue";
	Location loc;
	string value;
}

struct BooleanValue{
	string kind = "BooleanValue";
	Location loc;
	bool value;
}

struct EnumValue{
	string kind = "EnumValue";
	Location loc;
	string value;
}

struct ArrayValue(T){
	static if ( staticIndexOf!(T,Value) != -1 )	
	{
		string kind = "ArrayValue";
		Location loc;
		T[] values;
	}else{
		static assert(0, "Type not supported for Array.");
	}	
}

struct ObjectValue(OF){
	string kind = "ObjectValue";
	Location loc;
	ObjectField!(OF)[] fields;
}

struct ObjectField(T){
	static if ( staticIndexOf!(T,Value) != -1 )	
	{
		string kind = "ObjectField";
		Location loc;
		Name name;
		T value;
	}else{
		static assert(0, "Type not supported for Array.");
	}	
}

// Directives

struct Directive(A){
	string kind = "Directive";
	Location loc;
	Name name;
	Argument!(A)[] arguments;
}

// Types

alias Type = TypeTuple!(NamedType, ListType, NonNullType);

struct NamedType{
	string kind = "NamedType";
	Location loc;
	Name name;
}

struct ListType(T){
	static if ( staticIndexOf!(T,Type) != -1 )	
	{
		string kind = "ListType";
		Location loc;
		T type;
	}else{
		static assert(0, "Type not supported for Type.");
	}	
}

struct NonNullType(T){
	static if ( staticIndexOf!(T,TypeTuple!(NamedType, ListType)) != -1 )	
	{
		string kind = "NonNullType";
		Location loc;
		T type;
	}else{
		static assert(0, "Type not supported for NonNullType.");
	}	
}
