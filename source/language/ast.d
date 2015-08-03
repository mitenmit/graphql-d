import std.typetuple;
import std.typecons;
import std.variant;
import std.string;
import std.traits;

import source;

struct Location{
	int start;
	int end;
	Source source;
}

// Name

class Name{
	string kind = "Name";
	Location loc;
	string value;
	
	this(){}
	
	this(string kind, Location loc, string value){
		this.kind = kind;
		this.loc = loc;
		this.value = value;
	}
}

class Document{
	string kind = "Document";
	Location loc;
	Definition[] definitions;
	
	this(){}
	
	this(string kind, Location loc, Definition[] definitions){
		this.kind = kind;
		this.loc = loc;
		this.definitions = definitions.dup;
	}
}

class Definition{
	union{
		OperationDefinition m_opDef;	//1
		FragmentDefinition	m_fragDef;	//2
	}
	int kind = 0;
	
	this(){}
	
	this(OperationDefinition opDef){
		this.m_opDef = opDef;
		this.kind = 1;
	}
	
	this(FragmentDefinition fragDef){
		this.m_fragDef = fragDef;
		this.kind = 2;
	}
	
	void opAssign(OperationDefinition opDef){
		this.m_opDef = opDef;
		kind = 1;
	}
	
	void opAssign(FragmentDefinition fragDef){
		this.m_fragDef = fragDef;
		kind = 2;
	}
	
	/*
	void opCatAssign(OperationDefinition opDef){
		//this.m_opDef = opDef;
		//kind = 1;
		//return this.m_opDef;
	}
	
	void opAssign(FragmentDefinition fragDef){
		//this.m_fragDef = fragDef;
		//kind = 2;
		//return this.m_fragDef;
	}
	*/
	
	alias get this;
	
	@property inout(T) get(T)() inout
    {
		static if (is(T == OperationDefinition))
        {
            return this.m_opDef;
        }
		
		static if (is(T == FragmentDefinition)){
			return this.m_fragDef;
		}
		
		
		/*
		switch(kind){
			case 1: return this.m_opDef;
			case 2: return this.m_fragDef;
			default: break;
		}
		return m_opDef;
		*/
	}
}

class OperationDefinition{
	string kind = "OperationDefinition";
	Location loc;
	string operation;
	Name name;
	
	VariableDefinition[] variableDefinitions;
	Directive[] directives;
	SelectionSet selectionSet;
	
	this(){}
	
	this(
		string kind, 
		Location loc, 
		string operation, 
		Name name, 
		VariableDefinition[] variableDefinitions, 
		Directive[] directives,	
		SelectionSet selectionSet
	){
		
		this.kind = kind;
		this.loc = loc;
		this.operation = operation;
		this.name = name;
		
		this.variableDefinitions = variableDefinitions.dup;
		this.directives = directives.dup;
		this.selectionSet = selectionSet;
	}
}

class VariableDefinition{
	string kind = "VariableDefinition";
	Location loc;
	
	Variable variable;
	Type type;
	Value defaultValue;
	
	this(){}
	
	this(string kind, Location loc, Variable variable, Type type, Value defaultValue){
		this.kind = kind;
		this.loc = loc;
		
		this.variable = variable;
		this.type = type;
		this.defaultValue = defaultValue;
	}
}

class Variable{
	string kind = "Variable";
	Location loc;
	Name name;
	
	this(){}
	
	this(string kind, Location loc, Name name){
		this.kind = kind;
		this.loc = loc;
		this.name = name;
	}
}

class SelectionSet{
	string kind = "SelectionSet";
	Location loc;
	Selection[]	selections;
	
	this(){}
	
	this(string kind, Location loc, Selection[]	selections){
		this.kind = kind;
		this.loc = loc;
		this.selections = selections.dup;
	}
}

class Selection{
	union{
		Field			m_field;		//1
		FragmentSpread	m_fragSpread;	//2
		InlineFragment	m_inlineFrag;	//3
	}
	int kind = 0;
	
	this(){}
	
	this(Field field){
		this.m_field = field;
		this.kind = 1;
	}
	
	this(FragmentSpread fragSpread){
		this.m_fragSpread = fragSpread;
		this.kind = 2;
	}
	
	this(InlineFragment inlineFrag){
		this.m_inlineFrag = inlineFrag;
		this.kind = 3;
	}
	
	void opAssign(Field field){
		this.m_field = field;
		this.kind = 1;
	}
	
	void opAssign(FragmentSpread fragSpread){
		this.m_fragSpread = fragSpread;
		this.kind = 2;
	}
	
	void opAssign(InlineFragment inlineFrag){
		this.m_inlineFrag = inlineFrag;
		kind = 3;
	}
	
	alias get this;
	
	@property inout(T) get(T)() inout
    {
		static if (is(T == Field))
        {
            return this.m_field;
        }
		
		static if (is(T == FragmentSpread)){
			return this.m_fragSpread;
		}
		
		static if (is(T == InlineFragment)){
			return this.m_inlineFrag;
		}
		
		/*
		switch(kind){
			case 1: return this.m_field;
			case 2: return this.m_fragSpread;
			case 3: return this.m_inlineFrag;
			default: break;
		}
		return this.field;
		*/
	}
}

class Field{
	string kind = "Field";
	Location loc;
	Name fldAlias;
	Name name;
	Argument[] arguments;
	Directive[] directives;
	SelectionSet selectionSet;
	
	this(){}
	
	this(string kind, Location loc, Name fldAlias, Name name, Argument[] arguments, Directive[] directives, SelectionSet selectionSet){
		this.kind = kind;
		this.loc = loc;
		this.fldAlias = fldAlias;
		this.name = name;
		
		this.arguments = arguments.dup;
		this.directives = directives.dup;
		this.selectionSet = selectionSet;
	}
}

class Argument{	
	string kind = "Argument";
	Location loc;
	Name name;
	Value value;

	this(){}
	
	this(string kind, Location loc, Name name, Value value){
		this.kind = kind;
		this.loc = loc;
		this.name = name;
		
		this.value = value;
	}
}

// Fragments

class FragmentSpread{
	string kind = "FragmentSpread";
	Location loc;
	Name name;
	Directive[] directives;	
	
	this(){}
	
	this(string kind, Location loc, Name name, Directive[] directives){
		this.kind = kind;
		this.loc = loc;
		this.name = name;
		
		this.directives = directives.dup;
	}
}

class InlineFragment{
	string kind = "InlineFragment";
	Location loc;
	NamedType typeCondition;
	Directive[] directives;
	SelectionSet selectionSet;
	
	this(){}
	
	this(string kind, Location loc, NamedType typeCondition, Directive[] directives, SelectionSet selectionSet){
		this.kind = kind;
		this.loc = loc;
		this.typeCondition = typeCondition;
		
		this.directives = directives.dup;
		this.selectionSet = selectionSet;
	}
}

class FragmentDefinition{
	string kind = "FragmentDefinition";
	Location loc;
	Name name;
	NamedType typeCondition;
	Directive[] directives;
	SelectionSet selectionSet;
	
	this(){}
	
	this(string kind, Location loc, Name name,NamedType typeCondition, Directive[] directives, SelectionSet selectionSet){
		this.kind = kind;
		this.loc = loc;
		this.name = name;
		this.typeCondition = typeCondition;
		
		this.directives = directives.dup;
		this.selectionSet = selectionSet;
	}
}

// Values

class Value{
	union{
		Variable		m_var;		//1
		IntValue		m_intVal;	//2
		FloatValue		m_floatVal;	//3
		StringValue 	m_strVal;	//4
		BooleanValue	m_boolVal;	//5
		EnumValue		m_enumVal;	//6
		ListValue		m_listVal;	//7
		ObjectValue		m_objVal;	//8
	}
	
	int kind = 0;
	
	this(){}
	
	this(Variable var){
		this.m_var = var;
		this.kind = 1;
	}
	
	this(IntValue intVal){
		this.m_intVal = intVal;
		this.kind = 2;
	}
	
	this(FloatValue floatVal){
		this.m_floatVal = floatVal;
		this.kind = 3;
	}
	
	this(StringValue strVal){
		this.m_strVal = strVal;
		this.kind = 4;
	}
	
	this(BooleanValue boolVal){
		this.m_boolVal = boolVal;
		this.kind = 5;
	}
	
	this(EnumValue enumVal){
		this.m_enumVal = enumVal;
		this.kind = 6;
	}
	
	this(ListValue listVal){
		this.m_listVal = listVal;
		this.kind = 7;
	}
	
	this(ObjectValue objVal){
		this.m_objVal = objVal;
		this.kind = 8;
	}
	
	void opAssign(Variable var){
		this.m_var = var;
		this.kind = 1;
	}
	
	void opAssign(IntValue intVal){
		this.m_intVal = intVal;
		this.kind = 2;
	}
	
	void opAssign(FloatValue floatVal){
		this.m_floatVal = floatVal;
		this.kind = 3;
	}
	
	void opAssign(StringValue strVal){
		this.m_strVal = strVal;
		this.kind = 4;
	}
	
	void opAssign(BooleanValue boolVal){
		this.m_boolVal = boolVal;
		this.kind = 5;
	}
	
	void opAssign(EnumValue enumVal){
		this.m_enumVal = enumVal;
		this.kind = 6;
	}
	
	void opAssign(ListValue listVal){
		this.m_listVal = listVal;
		this.kind = 7;
	}
	
	void opAssign(ObjectValue objVal){
		this.m_objVal = objVal;
		this.kind = 8;
	}
	
	alias get this;
	
	@property inout(T) get(T)() inout
    {
		static if( is(T == Variable) ){
			return this.m_var;
		}
		static if (is(T == IntValue))
        {
            return this.m_intVal;
        }
		
		static if (is(T == FloatValue))
        {
            return this.m_floatVal;
        }
		
		static if (is(T == StringValue))
        {
            return this.m_strVal;
        }
		
		static if (is(T == BooleanValue))
        {
            return this.m_boolVal;
        }
		
		static if (is(T == EnumValue))
        {
            return this.m_enumVal;
        }
		
		static if (is(T == ListValue))
        {
            return this.m_listVal;
        }
		
		static if (is(T == ObjectValue))
        {
            return this.m_objVal;
        }
		
		/*
		switch(kind){
			case 1: return this.m_var;
			case 2: return this.m_intVal;
			case 3: return this.m_floatVal;
			case 4: return this.m_strVal;
			case 5: return this.m_boolVal;
			case 6: return this.m_enumVal;
			case 7: return this.m_listVal;
			case 8: return this.m_objVal;
			default: break;
		}
		
		return this.m_var;
		*/
	}
}

class IntValue{
	string kind = "IntValue";
	Location loc;
	string value;
	
	this(){}
	
	this(string kind, Location loc, string value){
		this.kind = kind;
		this.loc = loc;
		this.value = value;
	}
}

class FloatValue{
	string kind = "FloatValue";
	Location loc;
	string value;
	
	this(){}
	
	this(string kind, Location loc, string value){
		this.kind = kind;
		this.loc = loc;
		this.value = value;
	}
}

class StringValue{
	string kind = "StringValue";
	Location loc;
	string value;
	
	this(){}
	
	this(string kind, Location loc, string value){
		this.kind = kind;
		this.loc = loc;
		this.value = value;
	}
}

class BooleanValue{
	string kind = "BooleanValue";
	Location loc;
	bool value;
	
	this(){}
	
	this(string kind, Location loc, bool value){
		this.kind = kind;
		this.loc = loc;
		this.value = value;
	}
}

class EnumValue{
	string kind = "EnumValue";
	Location loc;
	string value;
	
	this(){}
	
	this(string kind, Location loc, string value){
		this.kind = kind;
		this.loc = loc;
		this.value = value;
	}
}

class ListValue{
	string kind = "ListValue";
	Location loc;
	Value[] values;
	
	this(){}
	
	this(string kind, Location loc, Value[] values){
		this.kind = kind;
		this.loc = loc;
		this.values = values.dup;
	}
}

class ObjectValue{
	string kind = "ObjectValue";
	Location loc;
	ObjectField[] fields;
	
	this(){}
	
	this(string kind, Location loc, ObjectField[] fields){
		this.kind = kind;
		this.loc = loc;
		this.fields = fields.dup;
	}
}

class ObjectField{
	string kind = "ObjectField";
	Location loc;
	Name name;
	Value value;
	
	this(){}
	
	this(string kind, Location loc, Name name, Value value){
		this.kind = kind;
		this.loc = loc;
		this.name = name;
		this.value = value;
	}
}

// Directives

class Directive{
	string kind = "Directive";
	Location loc;
	Name name;
	Argument[] arguments;
	
	this(){}
	
	this(string kind, Location loc, Name name, Argument[] arguments){
		this.kind = kind;
		this.loc = loc;
		this.name = name;
		this.arguments = arguments.dup;
	}
}

// Types

class Type{
	union{
		NamedType		m_namedType;	//1
		ListType		m_listType;		//2
		NonNullType		m_nonNullType;	//3
	}
	
	int kind = 0;
	
	this(){}
	
	this(NamedType namedType){
		this.m_namedType = namedType;
		this.kind = 1;
	}
	
	this(ListType listType){
		this.m_listType = listType;
		this.kind = 2;
	}
	
	this(NonNullType nonNullType){
		this.m_nonNullType = nonNullType;
		this.kind = 3;
	}
	
	void opAssign(NamedType namedType){
		this.m_namedType = namedType;
		this.kind = 1;
	}
	
	void opAssign(ListType listType){
		this.m_listType = listType;
		this.kind = 2;
	}
	
	void opAssign(NonNullType nonNullType){
		this.m_nonNullType = nonNullType;
		this.kind = 3;
	}
	
	alias get this;
	
	@property inout(T) get(T)() inout
    {
		switch(kind){
			case 1: return this.m_namedType; break;
			case 2: return this.m_listType; break;
			case 3: return this.m_nonNullType; break;
			default: break;
		}
		
		return this.m_namedType;
	}
}

class NamedType{
	string kind = "NamedType";
	Location loc;
	Name name;
	
	this(){}
	
	this(string kind, Location loc, Name name){
		this.kind = kind;
		this.loc = loc;
		this.name = name;
	}
}

class ListType{
	string kind = "ListType";
	Location loc;
	Type type;
	
	this(){}
	
	this(string kind, Location loc, Type type){
		this.kind = kind;
		this.loc = loc;
		this.type = type;
	}
}

class NonNullType{
	string kind = "NonNullType";
	Location loc;
	Type type;
	
	this(){}
	
	this(string kind, Location loc, Type type){
		this.kind = kind;
		this.loc = loc;
		this.type = type;
	}
}