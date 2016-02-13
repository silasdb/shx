#!/usr/bin/env atf-sh

. "$(pkg-config --variable=prefix shx)"/shx_io.sh
. "$(pkg-config --variable=prefix shx)"/shx_string.sh

quote_check ()
{
	res="$(shx_quote "$1")"
	if [ "$res" != "$2" ]; then
		atf_fail "$res != $2"
	fi
}

atf_test_case basic
basic_head ()
{
	atf_set  "descr"  "Test basic quote_check sequences"
}
basic_body ()
{
	quote_check 'foobar'		"'foobar'"
	quote_check 'a.dot'		"'a.dot'"
	quote_check 'a,comma'		"'a,comma'"
	quote_check 'no.quote.ok'	"'no.quote.ok'"
}

atf_test_case spaces
spaces_head ()
{
	atf_set  "descr"  "Test quote_check strings with white spaces and tabs"
}
spaces_body ()
{
	# Blank spaces
	quote_check 'foo bar'		"'foo bar'"
	quote_check ' '			"' '"
	quote_check '   '		"'   '"
}

atf_test_case dashes
dashes_head ()
{
	atf_set  "descr"  "Test quote_check strings with dashes for arguments"
}
dashes_body ()
{
	# Dashes
	quote_check '-n'		"'-n'"
	quote_check '-e'		"'-e'"
	quote_check '-e -n'		"'-e -n'"
	quote_check '-x'		"'-x'"
	quote_check '-v'		"'-v'"
	quote_check '-n a b -c'		"'-n a b -c'"
	quote_check '-e -- -c'		"'-e -- -c'"
	quote_check '-- -e'		"'-- -e'"
}

atf_test_case quotes
quotes_head ()
{
	atf_set  "descr"  "Test quote_check strings with simple and double quotes"
}
quotes_body ()
{
	# Simple quotes
	quote_check "'"		"''\'''"
	quote_check \'		"''\'''"
	# Double quotes
	quote_check '"'		"'\"'"
	quote_check \"			"'\"'"
}

atf_test_case special
special_head ()
{
	atf_set  "descr"  "Test quote_check strings other chars that need escaping"
}
special_body ()
{
	# Basic checking
	quote_check '!'		"'!'"
	quote_check '#'		"'#'"
	quote_check '$'		"'\$'"
	quote_check '&'		"'&'"
	quote_check '*'		"'*'"
	quote_check '('		"'('"
	quote_check ')'		"')'"
	quote_check '['		"'['"
	quote_check ']'		"']'"
	quote_check '`'		"'\`'"
	quote_check '<'		"'<'"
	quote_check '>'		"'>'"
	quote_check '?'		"'?'"
	quote_check '\\'	"'\\\\'"

	# Complex checking
	quote_check 'foo(bar)'		"'foo(bar)'"
	quote_check '(()))('		"'(()))('"
	quote_check 'foo[bar]'		"'foo[bar]'"
	quote_check '[][[]][['		"'[][[]][['"
	quote_check '<><>@&6-'		"'<><>@&6-'"
	quote_check '*abc*& '		"'*abc*& '"
	quote_check ' ? a $ '		"' ? a \$ '"
	quote_check '\ <\ )$\\'		"'\\ <\\ )\$\\\\'"
}


# Test the shx_field function.
# $1 -> field to try to pick out
# $2 -> the string
# $3 -> expected result
field_check ()
{
	local res
	# Test first form of shx_field
	res="$(shx_field "$1" "$2")"
	if [ "$res" != "$3" ]; then
		atf_fail "$res != $3"
	fi
	# Test second form of shx_field
	res="$(echo "$2" | shx_field "$1")"
	if [ "$res" != "$3" ]; then
		atf_fail "$res != $3"
	fi
}
field_head ()
{
	atf_set 'descr'  'Test the shx_field function'
}
field_body ()
{
	field_check 1 'foo bar more'	'foo'
	field_check 2 'foo bar more'	'bar'
	field_check 3 'foo bar more'	'more'
	field_check 1 'xx * ff'		'xx'
	field_check 2 'xx * ff'		'*'
	field_check 3 'xx * ff'		'ff'
	field_check 1 'xx * [ab] ff'	'xx'
	field_check 2 'xx * [ab] ff'	'*'
	field_check 3 'xx * [ab] ff'	'[ab]'
	field_check 1 'xx * [ab] ff'	'xx'
	field_check 2 'xx * [ab] ff'	'*'
	field_check 1 '/etc/* a b'	'/etc/*'
	field_check 2 '/etc/* a b'	'a'
}

# Test the shx_is_decimal function.
# $1 -> field to test
# $2 -> fail or pass?
is_decimal_check ()
{
	if [ "$2" = "pass" ]; then
		shx_is_decimal "$1" || atf_fail "$1 not integer"
	else
		shx_is_decimal "$1" && atf_fail "$1 is integer"
		# ATF doesn't allow us to return from a test with a non-ok exit
		# status.
		return 0
	fi
}

is_decimal_head ()
{
	atf_set 'descr'  'Test the shx_is_decimal function'
}
is_decimal_body ()
{
	is_decimal_check 1		pass
	is_decimal_check 10		pass
	is_decimal_check 010		pass
	is_decimal_check 239482		pass
	is_decimal_check '-342'		pass
	is_decimal_check 239.482	fail
	is_decimal_check 239,482	fail
	is_decimal_check 'sfdsf'	fail
	is_decimal_check /etc/*		fail
	is_decimal_check 12x324		fail
	is_decimal_check 0xffee		fail
}

atf_init_test_cases ()
{
	atf_add_test_case basic
	atf_add_test_case spaces
	atf_add_test_case dashes
	atf_add_test_case quotes
	atf_add_test_case special
	atf_add_test_case field
	atf_add_test_case is_decimal
}
