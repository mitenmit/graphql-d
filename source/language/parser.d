import std.stdio;

import source;
import lexer;
import ast;
import kinds;
import parsercore;

/**
 * Given a GraphQL source, parses it into a Document.
 * Throws GraphQLError if a syntax error is encountered.
 */

Document parse(Source source, ParseOptions options){
	Source sourceObj = source;
	Parser parser = makeParser(sourceObj, options);
	
	return parseDocument(parser);
}


/**
 * Given a string containing a GraphQL value, parse the AST for that value.
 * Throws GraphQLError if a syntax error is encountered.
 *
 * This is useful within tools that operate upon GraphQL Values directly and
 * in isolation of complete GraphQL documents.
 */
 
Value parseValue(Source source, ParseOptions options){
	Source sourceObj = source;
	Parser parser = makeParser(sourceObj, options);
	
	return parseValueLiteral(parser, false);
}

Value parseValue(string source, ParseOptions options){
	Source sourceObj = new Source(source, "");
	Parser parser = makeParser(sourceObj, options);
	
	return parseValueLiteral(parser, false);
}

/**
 * Converts a name lex token into a name parse node.
 */
Name parseName(Parser parser){
	Token token = expect(parser, TokenKind.NAME);
	return new Name(NAME, loc(parser, token.start), token.value);
}

// Implements the parsing rules in the Document section.

Document parseDocument(Parser parser){
	int start = parser.token.start;
	Definition[] definitions;
	
	do{
		if( peek(parser, TokenKind.BRACE_L) ){
			definitions ~= new Definition( parseOperationDefinition(parser) );
		}else if( peek(parser, TokenKind.NAME) ){
			if(parser.token.value == "query" || parser.token.value == "mutation"){
				definitions ~= new Definition( parseOperationDefinition(parser) );
			}else if( parser.token.value == "fragment" ){
				definitions ~= new Definition( parseFragmentDefinition(parser) );
			} else {
				//throw unexpected(parser);
			}
		} else {
			//throw unexpected(parser);
		}
	} while( !skip(parser, TokenKind.EOF) );
	
	return new Document(DOCUMENT, loc(parser, start), definitions);
}

OperationDefinition parseOperationDefinition(Parser parser){
	int start = parser.token.start;
	
	if( peek(parser, TokenKind.BRACE_L) ){
		SelectionSet selectionSet = parseSelectionSet(parser);
		
		return new OperationDefinition(
			OPERATION_DEFINITION,
			loc(parser, start),
			"query",
			null,
			null,
			[],
			selectionSet
		);
	}
	
	Token operationToken = expect(parser, TokenKind.NAME);
	
	string operation = operationToken.value;
	Name name = parseName(parser);
	VariableDefinition[] variableDefinitions = parseVariableDefinitions(parser);
	Directive[] directives = parseDirectives(parser);
	SelectionSet selectionSet =  parseSelectionSet(parser);
	
	return new OperationDefinition(
		OPERATION_DEFINITION,
		loc(parser, start),
		operation,
		name,
		variableDefinitions,
		directives,
		selectionSet
	);
}

VariableDefinition[] parseVariableDefinitions(Parser parser){
	return peek(parser, TokenKind.PAREN_L) ? 
		many(
			parser, 
			TokenKind.PAREN_L, 
			&parseVariableDefinition, 
			TokenKind.PAREN_R
		) : [];
}

VariableDefinition parseVariableDefinition(Parser parser){
	int start = parser.token.start;
	
	return new VariableDefinition(
		VARIABLE_DEFINITION,
		loc(parser, start),
		parseVariable(parser),
		parseType(parser),
		skip(parser, TokenKind.EQUALS) ? parseValueLiteral(parser, true) : null
	);
}

Variable parseVariable(Parser parser){
	int start = parser.token.start;
	expect(parser, TokenKind.DOLLAR);
	
	return new Variable(
		VARIABLE,
		loc(parser, start),
		parseName(parser)
	);
}

SelectionSet parseSelectionSet(Parser parser){
	int start = parser.token.start;
	
	auto res = many(parser, TokenKind.BRACE_L, &parseSelection, TokenKind.BRACE_R);
	
	return new SelectionSet(
		SELECTION_SET,
		loc(parser, start),
		res
	);
}

Selection parseSelection(Parser parser){
	return peek(parser, TokenKind.SPREAD) ? new Selection(parseFragment(parser)) : new Selection( parseField(parser) ); 
}

/**
 * Corresponds to both Field and Alias in the spec
 */
 
Field parseField(Parser parser){
	int start = parser.token.start;
	
	Name nameOrAlias = parseName(parser);
	Name name, _alias;
	
	if( skip(parser, TokenKind.COLON) ){
		_alias = nameOrAlias;
		name = parseName(parser);
	} else {
		_alias = null;
		name = nameOrAlias;
	}
	
	Argument[] arguments = parseArguments(parser);
	Directive[] directives = parseDirectives(parser);
	SelectionSet selectionSet = peek(parser, TokenKind.BRACE_L) ? parseSelectionSet(parser) : null;
	
	return new Field(
		FIELD,
		loc(parser, start),
		_alias,
		name,
		arguments,
		directives,
		selectionSet,
	);
 }
 
Argument[] parseArguments(Parser parser) {
	return peek(parser, TokenKind.PAREN_L) ? 
		many(parser, TokenKind.PAREN_L, &parseArgument, TokenKind.PAREN_R) : 
		[];
}

Argument parseArgument(Parser parser){
	int start = parser.token.start;
	Name name = parseName(parser);
	expect(parser, TokenKind.COLON);
	Value value = parseValueLiteral(parser, false);
	
	return new Argument(
		ARGUMENT,
		loc(parser, start),
		name,
		value
	);
}

// Implements the parsing rules in the Fragments section.

/**
 * Corresponds to both FragmentSpread and InlineFragment in the spec
 */
 
 //TODO: Return FragmentSpread | InlineFragment
FragmentSpread parseFragment(Parser parser){
	int start = parser.token.start;
	
	expect(parser, TokenKind.SPREAD);
	if(parser.token.value == "on"){
		advance(parser);
		NamedType namedType = parseNamedType(parser);
		Directive[] iDirectives = parseDirectives(parser);
		SelectionSet selectionSet = parseSelectionSet(parser);
		/*
		return new InlineFragment(
			INLINE_FRAGMENT,
			loc(parser, start),
			namedType,
			iDirectives,
			selectionSet
		);
		*/
	}
	
	Name name = parseFragmentName(parser);
	Directive[] directives = parseDirectives(parser);
	
	return new FragmentSpread(
		FRAGMENT_SPREAD,
		loc(parser, start),
		name,
		directives
	);
	
}

Name parseFragmentName(Parser parser){
	if(parser.token.value == "on"){
		//throw unexpected(parser);
	}
	
	return parseName(parser);
}

FragmentDefinition parseFragmentDefinition(Parser parser){
	int start = parser.token.start;
	expectKeyword(parser, "fragment");
	
	Name name = parseFragmentName(parser);
	expectKeyword(parser, "on");
	NamedType namedType = parseNamedType(parser);
	Directive[] directives = parseDirectives(parser);
	SelectionSet selectionSet = parseSelectionSet(parser);
	
	return new FragmentDefinition(
		FRAGMENT_DEFINITION,
		loc(parser, start),
		name,
		namedType,
		directives,
		selectionSet
	);
}

// Implements the parsing rules in the Values section.

Value parseConstValue(Parser parser){
	return parseValueLiteral(parser, true);
}

Value parseVariableValue(Parser parser){
	return parseValueLiteral(parser, false);
}

Value parseValueLiteral(Parser parser, bool isConst){
	Token token = parser.token;
	
	switch(token.kind){
		case TokenKind.BRACKET_L: 
			return new Value( parseList(parser, isConst) ); 
			
		case TokenKind.BRACE_L:
			return new Value( parseObject(parser, isConst) );
			
		case TokenKind.INT:
			advance(parser);
			string value = token.value;
			return new Value(new IntValue(INT, loc(parser, token.start), value ));
			
		case TokenKind.FLOAT:
			advance(parser);
			string value = token.value;
			return new Value(new FloatValue(FLOAT, loc(parser, token.start), value));
			
		case TokenKind.STRING:
			advance(parser);
			string value = token.value;
			return new Value(new StringValue(STRING, loc(parser, token.start), value));
			
		case TokenKind.NAME:
			if(token.value == "true" || token.value == "false"){
				advance(parser);
				bool value = token.value == "true";
				return new Value( new BooleanValue(BOOLEAN, loc(parser, token.start), value) );
			}else if(token.value != "null"){
				advance(parser);
				string value = token.value;
				return new Value( new EnumValue(ENUM, loc(parser, token.start), value) );
			}
			break;
		case TokenKind.DOLLAR:
				if(!isConst){
					return new Value( parseVariable(parser) );
				}
			break;
		default:
			break;
	}
	
	//throw unexpected(parser);
	return new Value();
}

ListValue parseList(Parser parser, bool isConst){
	int start = parser.token.start;
	
	Value[] values = any(
						parser, 
						TokenKind.BRACKET_L, 
						isConst ? &parseConstValue : &parseVariableValue,
						TokenKind.BRACKET_R
					);
	
	return new ListValue(
		LIST,
		loc(parser, start),
		values
	);
}

ObjectValue parseObject(Parser parser, bool isConst){
	int start = parser.token.start;
	expect(parser, TokenKind.BRACE_L);
	bool[string] fieldNames;
	ObjectField[] fields;
	
	while( !skip(parser, TokenKind.BRACE_R) ) {
		fields ~= parseObjectField(parser, isConst, fieldNames);
	}
	
	return new ObjectValue(
		OBJECT,
		loc(parser, start),
		fields
	);
}

ObjectField parseObjectField(Parser parser, bool isConst, bool[string] fieldNames){
	int start = parser.token.start;
	Name name = parseName(parser);
	
	if(name.value in fieldNames){
		//throw syntaxError(parser.source, start, "Duplicate input object field "~name.value);
	}
	
	fieldNames[name.value] = true;
	expect(parser, TokenKind.COLON);
	Value value = parseValueLiteral(parser, isConst);
	
	return new ObjectField(
		OBJECT_FIELD,
		loc(parser, start),
		name,
		value
	);
}

// Implements the parsing rules in the Directives section.

Directive[] parseDirectives(Parser parser){
	Directive[] directives;
	
	while( peek(parser, TokenKind.AT) ){
		directives ~= parseDirective(parser);
	}
	
	return directives;
}

Directive parseDirective(Parser parser){
	int start = parser.token.start;
	
	expect(parser, TokenKind.AT);
	Name name = parseName(parser);
	Argument[] arguments = parseArguments(parser);
	
	return new Directive(
		DIRECTIVE,
		loc(parser, start),
		name,
		arguments
	);
}

// Implements the parsing rules in the Types section.

/**
 * Handles the Type: NamedType, ListType, and NonNullType parsing rules.
 */
 
Type parseType(Parser parser){
	int start = parser.token.start;
	
	Type type;
	
	if( skip(parser, TokenKind.BRACKET_L) ){
		type = parseType(parser);
		expect(parser, TokenKind.BRACKET_R);
		type = new Type(new ListType(LIST_TYPE, loc(parser, start),type) );
	} else {
		type = new Type( parseNamedType(parser) );
	}
	
	if(skip( parser, TokenKind.BANG) ){
		return new Type(new NonNullType(
			NON_NULL_TYPE,
			loc(parser, start),
			type
		));
	}
	
	return type;
}

NamedType parseNamedType(Parser parser){
	int start = parser.token.start;
	Name name = parseName(parser);
	
	return new NamedType(
		NAMED_TYPE,
		loc(parser, start),
		name
	);
}