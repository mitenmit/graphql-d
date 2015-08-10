import std.stdio;

import ast;
import schema;

/**
 * These are all of the possible kinds of types.
 */

 class GraphQLType{
	
 }
 
// Predicates

/**
 * These types may be used as input types for arguments and directives.
 */
 
class GraphQLInputType{
	
}

bool isInputType(GraphQLType type){
	//GraphQLNamedType namedType = getNamedType(type);
	return false;
}


/**
 * These types may be used as output types as the result of fields.
 */
 class GraphQLOutputType{
	
 }
 
bool isOutputType(GraphQLType type){
	return false;
}

/**
 * These types may describe types which may be leaf values.
 */
 
class GraphQLLeafType{
}

bool isLeafType(GraphQLType type){
	return false;
}

/**
 * These types may describe the parent context of a selection set.
 */
 
class GraphQLCompositeType{
}

bool isCompositeType(GraphQLType type){
	return false;
}

/**
 * These types may describe the parent context of a selection set.
 */
 
class GraphQLAbstractType{
}

bool isAbstractType(GraphQLType type){
	return false;
}

/**
 * These types can all accept null as a value.
 */
 
class GraphQLNullableType{
	
}

GraphQLNullableType getNullableType(GraphQLType type){
	return null;
}

/**
 * These named types do not include modifiers like List or NonNull.
 */
class GraphQLNamedType{
}

GraphQLNamedType getNamedType(GraphQLType type){
	GraphQLType unmodifiedType = type;
	
	while(
		is(typeof(unmodifiedType) == GraphQLList) || 
		is(typeof(unmodifiedType) == GraphQLNonNull)
	){
		unmodifiedType = unmodifiedType.ofType;
	}
	
	return unmodifiedType;
}

/**
 * Scalar Type Definition
 *
 * The leaf values of any request and input values to arguments are
 * Scalars (or Enums) and are defined with a name and a series of coercion
 * functions used to ensure validity.
 *
 * Example:
 *
 *     var OddType = new GraphQLScalarType({
 *       name: 'Odd',
 *       coerce(value) {
 *         return value % 2 === 1 ? value : null;
 *       }
 *     });
 *
 */
 
class GraphQLScalarType(T){
	string name;
	string description;
	
	GraphQLScalarTypeConfig!T _scalarConfig;
	
	this(){}
	
	this(GraphQLScalarTypeConfig!T config){
		//invariant(config.name, "Type must be named");
		this.name = config.name;
		this.description = config.description;
		this._scalarConfig = config;
	}
	
	override string toString(){
		return this.name;
	}
}

class GraphQLScalarTypeConfig(T){
	string name;
	string description;
	
	T function(Object value) coerce;
	T function(Value value) coerceLiteral;
}

/**
 * Object Type Definition
 *
 * Almost all of the GraphQL types you define will be object types. Object types
 * have a name, but most importantly describe their fields.
 *
 * Example:
 *
 *     var AddressType = new GraphQLObjectType({
 *       name: 'Address',
 *       fields: {
 *         street: { type: GraphQLString },
 *         number: { type: GraphQLInt },
 *         formatted: {
 *           type: GraphQLString,
 *           resolve(obj) {
 *             return obj.number + ' ' + obj.street
 *           }
 *         }
 *       }
 *     });
 *
 * When two types need to refer to each other, or a type needs to refer to
 * itself in a field, you can use a function expression (aka a closure or a
 * thunk) to supply the fields lazily.
 *
 * Example:
 *
 *     var PersonType = new GraphQLObjectType({
 *       name: 'Person',
 *       fields: () => ({
 *         name: { type: GraphQLString },
 *         bestFriend: { type: PersonType },
 *       })
 *     });
 *
 */
 
class GraphQLObjectType{
	string name;
	string description;
	
	
}

T resolveMaybeThunk(T)(T thingOrThung){
	return thingOrThung;
}

T resolveMaybeThunk(T)(T function() thingOrThung){
	return thingOrThung();
}

GraphQLInterfaceType[] defineInterface(T)(T interfacesOrThunk){
	return resolveMaybeThunk(interfacesOrThunk);
}

GraphQLFieldDefinitionMap defineFieldMap(GraphQLFieldConfigMap fields){
	return null;
}

/**
 * Update the interfaces to know about this implementation.
 * This is an rare and unfortunate use of mutation in the type definition
 * implementations, but avoids an expensive "getPossibleTypes"
 * implementation for Interface types.
 */
 
void addImplementationToInterface(T)(T impl){
}

class GraphQLObjectTypeConfig{
	string name;
	string description;
}

alias GraphQLInterfaceType[] function() GraphQLInterfacesThunk;
alias GraphQLFieldConfigMap function() GraphQLFieldConfigMapThunk;

class GraphQLFieldConfig{
	
}

alias GraphQLArgumentConfig[string] GraphQLFieldConfigArgumentMap;

class GraphQLArgumentConfig{
}

alias GraphQLFieldConfig[string] GraphQLFieldConfigMap;

class GraphQLFieldDefinition{
}

class GraphQLArgument{
	string name;
	GraphQLInputType type;
	//defaultValue
	string description;
}

alias GraphQLFieldDefinition[string] GraphQLFieldDefinitionMap;

/**
 * Interface Type Definition
 *
 * When a field can return one of a heterogeneous set of types, a Interface type
 * is used to describe what types are possible, what fields are in common across
 * all types, as well as a function to determine which type is actually used
 * when the field is resolved.
 *
 * Example:
 *
 *     var EntityType = new GraphQLInterfaceType({
 *       name: 'Entity',
 *       fields: {
 *         name: { type: GraphQLString }
 *       }
 *     });
 *
 */
 
 class GraphQLInterfaceType{
	string name;
	string secription;
	
	GraphQLInterfaceTypeConfig _typeConfig;
	GraphQLFieldDefinitionMap _fields;
	GraphQLObjectType[] _implementations;
	bool[string] _possibleTypeNames;
	
	this(){}
	
	this(GraphQLInterfaceTypeConfig config){
	}
	
	GraphQLFieldDefinitionMap getFields(){
		return null;
	}
	
	GraphQLObjectType[] getPossibleTypes(){
		return this._implementations;
	}
	
	bool isPosibleType(GraphQLObjectType type){
		return true;
	}
	
	GraphQLObjectType resolveType(T)(T value){
		return null;
	}
	
	override string toString(){
		return this.name;
	}
	
 }
 
GraphQLObjectType getTypeOf(T)(T value, GraphQLAbstractType abstractType){
	return null;
}

class GraphQLInterfaceTypeConfig{
	string name;
}

/**
 * Union Type Definition
 *
 * When a field can return one of a heterogeneous set of types, a Union type
 * is used to describe what types are possible as well as providing a function
 * to determine which type is actually used when the field is resolved.
 *
 * Example:
 *
 *     var PetType = new GraphQLUnionType({
 *       name: 'Pet',
 *       types: [ DogType, CatType ],
 *       resolveType(value) {
 *         if (value instanceof Dog) {
 *           return DogType;
 *         }
 *         if (value instanceof Cat) {
 *           return CatType;
 *         }
 *       }
 *     });
 *
 */
 
class GraphQLUnionType {
	string name;
	string description;
	
	GraphQLUnionTypeConfig _typeConfig;
	GraphQLObjectType[] _types;
	bool[string] _possibleTypeNames;
	
	this(){}
	
	this(GraphQLUnionTypeConfig config){
	}
	
	GraphQLObjectType[] getPossibleTypes(){
		return this._types;
	}
	
	bool isPossibleType(GraphQLObjectType type){
		bool[string] possibleTypeNames = this._possibleTypeNames.dup;
		
		return possibleTypeNames[type.name] == true;
	}
	
	GraphQLObjectType resolveType(T)(T value){
		return null;
	}
	
	override string toString(){
		return this.name;
	}
}

class GraphQLUnionTypeConfig{
	string name;
}

/**
 * Enum Type Definition
 *
 * Some leaf values of requests and input values are Enums. GraphQL serializes
 * Enum values as strings, however internally Enums can be represented by any
 * kind of type, often integers.
 *
 * Example:
 *
 *     var RGBType = new GraphQLEnumType({
 *       name: 'RGB',
 *       values: {
 *         RED: { value: 0 },
 *         GREEN: { value: 1 },
 *         BLUE: { value: 2 }
 *       }
 *     });
 *
 * Note: If a value is not provided in a definition, the name of the enum value
 * will be used as it's internal value.
 */
class GraphQLEnumType(T){
	string name;
	string description;
	GraphQLEnumTypeConfig!T _enumConfig;
	GraphQLEnumValueDefinitionMap!T _values;
	GraphQLEnumValueDefinition[string] _nameLookup;
	
	this(){}
	
	this(GraphQLEnumTypeConfig!T config){
		this.name = config.name;
		this.description = config.description;
		this._enumConfig = config;
	}
	
	GraphQLEnumValueDefinitionMap!T getValues(){
		//if(!this._values) this._values = this._defineValueMap();
		return this._values;
	}
	
	string coerce(T value){
		return "";
	}
	
	//T coerceLiteral(){}
	
	GraphQLEnumValueDefinitionMap!T _defineValueMap(){
		return null;
	}
}

class GraphQLEnumTypeConfig(T){
	string name;
	GraphQLEnumValueConfigMap!T values;
	string description;
}

template GraphQLEnumValueConfigMapDef(T){
	alias GraphQLEnumValueConfig!T[string] GraphQLEnumValueConfigMapDef;
}

class GraphQLEnumValueConfig(T){
	T value;
	string deprecationReason;
	string description;
}

template GraphQLEnumValueDefinitionMap(T){
	alias GraphQLEnumValueDefinition!T[string] GraphQLEnumValueDefinitionMap;
}

class GraphQLEnumValueDefinition(T){
	string name;
	T value;
	string deprecationReason;
	string description;
}

/**
 * Input Object Type Definition
 *
 * An input object defines a structured collection of fields which may be
 * supplied to a field argument.
 *
 * Using `NonNull` will ensure that a value must be provided by the query
 *
 * Example:
 *
 *     var GeoPoint = new GraphQLInputObjectType({
 *       name: 'GeoPoint',
 *       fields: {
 *         lat: { type: new GraphQLNonNull(GraphQLFloat) },
 *         lon: { type: new GraphQLNonNull(GraphQLFloat) },
 *         alt: { type: GraphQLFloat, defaultValue: 0 },
 *       }
 *     });
 *
 */
 
class GraphQLInputObjectType{
	string name;
	string description;
	
	InputObjectConfig _typeConfig;
	InputObjectFieldMap _fields;
	
	this(){}
	
	this(InputObjectConfig config){
	}
}

class InputObjectConfig{
	string name;
	InputObjectConfigFieldMapThunk fields;
	string description;
}

alias InputObjectConfigFieldMap function() InputObjectConfigFieldMapThunk;

class InputObjectFieldConfig{
	GraphQLInputType type;
	//defaultValue
	string description;
}

alias InputObjectFieldConfig[string] InputObjectConfigFieldMap;

class InputObjectField{
	string name;
	GraphQLInputType type;
	//defaultValue
	string description;
}

alias InputObjectField[string] InputObjectFieldMap;

/**
 * List Modifier
 *
 * A list is a kind of type marker, a wrapping type which points to another
 * type. Lists are often created within the context of defining the fields of
 * an object type.
 *
 * Example:
 *
 *     var PersonType = new GraphQLObjectType({
 *       name: 'Person',
 *       fields: () => ({
 *         parents: { type: new GraphQLList(Person) },
 *         children: { type: new GraphQLList(Person) },
 *       })
 *     })
 *
 */
 
class GraphQLList{
	GraphQLType ofType;
	
	this(){}
	
	this(GraphQLType type){
		this.ofType = type;
	}
	
	override string toString(){
		return "["~this.ofType.toString()~"]";
	}
	
}

/**
 * Non-Null Modifier
 *
 * A non-null is a kind of type marker, a wrapping type which points to another
 * type. Non-null types enforce that their values are never null and can ensure
 * an error is raised if this ever occurs during a request. It is useful for
 * fields which you can make a strong guarantee on non-nullability, for example
 * usually the id field of a database row will never be null.
 *
 * Example:
 *
 *     var RowType = new GraphQLObjectType({
 *       name: 'Row',
 *       fields: () => ({
 *         id: { type: new GraphQLNonNull(String) },
 *       })
 *     })
 *
 * Note: the enforcement of non-nullability occurs within the executor.
 */
class GraphQLNonNull{
	GraphQLType ofType;
	
	this(){}
	
	this(GraphQLType type){
		//invariant();
		this.ofType = type;
	}
	
	override string toString(){
		return this.ofType.toString()~"!";
	}
}

