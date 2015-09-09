import std.stdio;
import std.conv;
import std.traits;

import ast;
import app;


template UnionType(Types...){
	private auto getUnionContent() {
        string s;
        foreach(T; Types) {
            s ~=  fullyQualifiedName!T ~ " member_" ~ T.mangleof ~ ";";
			//s ~=  T.stringof ~ " member_" ~ T.mangleof ~ ";";
        }

        return s;
    }
	
	private auto getTag() {
        string s;
        foreach(T; Types) {
            s ~= T.mangleof ~ ",";
        }

        return "enum Tag {" ~ s ~ "}";
    }

    private auto getSwitchContent() {
        string s;
        foreach(T; Types) {
            s ~= "case Tag." ~ T.mangleof;
            s ~= ": return fun(member_" ~ T.mangleof ~ ");";
        }

        return s;
    }
	
	class UnionType{
		
        union {
            mixin(getUnionContent());
        }

        mixin(getTag());

        Tag tag;
		
		this(T)(T t) if(is(typeof(mixin("Tag." ~ T.mangleof)))) {
            mixin("tag = Tag." ~ T.mangleof ~ ";");
            mixin("member_" ~ T.mangleof ~ " = t;");
        }
		
		void opAssign(T)(T t) if(is(typeof(mixin("Tag." ~ T.mangleof)))) {
            mixin("tag = Tag." ~ T.mangleof ~ ";");
            mixin("member_" ~ T.mangleof ~ " = t;");
        }
		
		alias get this;
		
		@property inout(T) get(T)() inout
		{
			 mixin("return member_" ~ T.mangleof ~ ";");
		}
		
	}
}