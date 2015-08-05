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
	return null;
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
	return null;
}