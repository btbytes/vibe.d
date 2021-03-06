/**
	Utiltiy functions for string processing

	Copyright: © 2012 Sönke Ludwig
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
	Authors: Sönke Ludwig
*/
module vibe.utils.string;

public import std.string;

import std.array;
import core.exception;


/**
	Takes a string with possibly invalid UTF8 sequences and outputs a valid UTF8 string as near to
	the original as possible.
*/
string sanitizeUTF8(in ubyte[] str)
{
	import std.utf;
	auto ret = appender!string();

	size_t i = 0;
	while( i < str.length ){
		dchar ch = str[i];
		try ch = std.utf.decode(cast(string)str, i);
		catch( UTFException ){ i++; }
		catch( AssertError ){ i++; }
		char[4] dst;
		auto len = std.utf.encode(dst, ch);
		ret.put(dst[0 .. len]);
	}

	return ret.data;
}

/**
	Joins an array of strings using 'linesep' as the line separator (\n by default).
*/
string joinLines(string[] strs, string linesep = "\n")
{
	auto ret = appender!string();
	foreach( i, s; strs ){
		if( i > 0 ) ret.put(linesep);
		ret.put(s);
	}
	return ret.data;
}

/**
	Checks if all characters in 'str' are contained in 'chars'.
*/
bool allOf(string str, string chars)
{
	foreach( ch; str )
		if( chars.indexOf(ch) < 0 )
			return false;
	return true;
}

/**
	Checks if any character in 'str' is contained in 'chars'.
*/
bool anyOf(string str, string chars)
{
	foreach( ch; str )
		if( chars.indexOf(ch) >= 0 )
			return true;
	return false;
}

bool isAlpha(char ch)
{
	switch( ch ){
		default: return false;
		case 'a': .. case 'z'+1: break;
		case 'A': .. case 'Z'+1: break;
	}
	return true;
}
