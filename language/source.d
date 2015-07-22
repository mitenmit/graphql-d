import std.stdio;

class Source{
	string srcBody;
	string srcName;
	
	this(){}
	
	this(string pBody, string pName)
	{
		srcBody = pBody;
		srcName = pName && pName.length>0 ? pName : "GraphQL";
	}
}