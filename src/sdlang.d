/// SDLang-D
/// Written in the D programming language.

/++
Library for parsing SDL (Simple Declarative Language).
SDL: http://sdl.ikayzo.org/display/SDL/Language+Guide

Author:
$(WEB www.semitwist.com, Nick Sabalausky)

This should work with DMD 2.059 and up.

To compile manually:
	rdmd --build-only -Isrc -ofbin/sdlang [dmd/rdmd options] src/sdlang.d

You can also compile with stbuild (part of SemiTwist D Tools):
	semitwist-stbuild all [release|debug|all]

	Installation instructions for SemiTwist D Tools are here:
		http://semitwist.com/goldie/Start/Install/
+/

module sdlang;

import std.datetime;
import std.file;
import std.stdio;

import sdlang_impl.lexer;
import sdlang_impl.symbol;
import sdlang_impl.token;

int main(string[] args)
{
	if(args.length != 2)
	{
		stderr.writeln("Usage: sdlang filename.sdl");
		return 1;
	}
	
	auto filename = args[1];
	auto source = cast(string)read(filename);
	
	auto s = symbol!"Value";
	auto t = Token(s);
	auto lexer = Lexer(source, filename);
	
	foreach(tok; lexer)
		writeln(
			"[", tok.line, ":", tok.col, "] ",
			tok.symbol.name, "(", toString(tok.value.type), "): ",
			tok.data
		);
	
	return 0;
}

string toString(TypeInfo ti)
{
	if     (ti == typeid( string       )) return "string";
	else if(ti == typeid( dchar        )) return "dchar";
	else if(ti == typeid( int          )) return "int";
	else if(ti == typeid( long         )) return "long";
	else if(ti == typeid( float        )) return "float";
	else if(ti == typeid( double       )) return "double";
	else if(ti == typeid( real         )) return "real";
	else if(ti == typeid( Date         )) return "Date";
	else if(ti == typeid( DateTime     )) return "DateTime";
	else if(ti == typeid( Duration     )) return "Duration";
	else if(ti == typeid( void[]       )) return "void[]";
	else if(ti == typeid( typeof(null) )) return "null";
	
	return "{unknown}";
}