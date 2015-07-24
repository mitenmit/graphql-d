import std.typetuple;
import std.typecons;
import std.string;
import std.traits;

alias Dictionary = TypeTuple!(float, int, char);

struct MyType(T){
	static if ( staticIndexOf!(T,Dictionary) != -1 )	
	{		
		T number;
	}else{
		static assert(0, "Type not supported.");
	}
}
