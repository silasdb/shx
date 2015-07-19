#!/bin/sh

Prog_Name=${0##*/}

. /usr/share/atf/atf.header.subr

. ../shx_io.sh
. ../shx_string.sh

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
	atf_set  "descr"  "Test basic quote sequences"
}
basic_body ()
{
	quote 'foobar'		"'foobar'"
	quote 'a.dot'		"'a.dot'"
	quote 'a,comma'		"'a,comma'"
	quote 'no.quote.ok'	"'no.quote.ok'"
}

atf_test_case spaces
spaces_head ()
{
	atf_set  "descr"  "Test quote strings with white spaces and tabs"
}
spaces_body ()
{
	# Blank spaces
	quote 'foo bar'		"'foo bar'"
	quote ' '		"' '"
	quote '   '		"'   '"
}

atf_test_case dashes
dashes_head ()
{
	atf_set  "descr"  "Test quote strings with dashes for arguments"
}
dashes_body ()
{
	# Dashes
	quote '-n'		"'-n'"
	quote '-e'		"'-e'"
	quote '-e -n'		"'-e -n'"
	quote '-x'		"'-x'"
	quote '-v'		"'-v'"
	quote '-n a b -c'	"'-n a b -c'"
	quote '-e -- -c'		"'-e -- -c'"
	quote '-- -e'		"'-- -e'"
}

atf_test_case quotes
quotes_head ()
{
	atf_set  "descr"  "Test quote strings with simple and double quotes"
}
quotes_body ()
{
	# Simple quotes
	quote "'"		"''\'''"
	quote \'			"''\'''"
	# Double quotes
	quote '"'		"'\"'"
	quote \"			"'\"'"
}

atf_test_case special
special_head ()
{
	atf_set  "descr"  "Test quote strings other chars that need escaping"
}
special_body ()
{
	# Basic checking
	quote '!'		"'!'"
	quote '#'		"'#'"
	quote '$'		"'\$'"
	quote '&'		"'&'"
	quote '*'		"'*'"
	quote '('		"'('"
	quote ')'		"')'"
	quote '['		"'['"
	quote ']'		"']'"
	quote '`'		"'\`'"
	quote '<'		"'<'"
	quote '>'		"'>'"
	quote '?'		"'?'"
	quote '\\'		"'\\\\'"

	# Complex checking
	quote 'foo(bar)'		"'foo(bar)'"
	quote '(()))('		"'(()))('"
	quote 'foo[bar]'		"'foo[bar]'"
	quote '[][[]][['		"'[][[]][['"
	quote '<><>@&6-'		"'<><>@&6-'"
	quote '*abc*& '		"'*abc*& '"
	quote ' ? a $ '		"' ? a \$ '"
	quote '\ <\ )$\\'	"'\\ <\\ )\$\\\\'"
}

atf_init_test_cases ()
{
	atf_add_test_case basic
	atf_add_test_case spaces
	atf_add_test_case dashes
	atf_add_test_case quotes
	atf_add_test_case special
}

. /usr/share/atf/atf.footer.subr

main "$@"
