import std.stdio;
import std.conv;

import definition;

/**
 * Schema Definition
 *
 * A Schema is created by supplying the root types of each type of operation,
 * query and mutation (optional). A schema definition is then supplied to the
 * validator and executor.
 *
 * Example:
 *
 *     var MyAppSchema = new GraphQLSchema({
 *       query: MyAppQueryRootType
 *       mutation: MyAppMutationRootType
 *     });
 *
 */
 
class GraphQLSchema{
	
	this(){}
}