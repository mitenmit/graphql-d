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
	
	alias get this;
	
	@property inout(T) get(T)() inout
    {
		switch(kind){
			case 1: return this.m_opDef; break;
			case 2: return this.m_fragDef; break;
			default: break;
		}
		return m_opDef;
	}
}

class OperationDefinition{
	string kind = "OperationDefinition";
	Location loc;
	string operation;
	Name name;
	
	VariableDefinition[] variableDefinitions;
	//Directive[] directives;
	SelectionSet selectionSet;
}

class VariableDefinition{
	string kind = "VariableDefinition";
	Location loc;
	
	Variable variable;
	//Type type;
	//Value defaultValue;
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
	
	this(string kind, Location loc, Selection[]	selections){
		this.kind = kind;
		this.loc = loc;
		this.selections = selections.dup;
	}
}

class Selection{
	
}


class FragmentDefinition{
}