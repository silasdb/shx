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

atf_init_test_cases ()
{
	atf_add_test_case basic
	atf_add_test_case spaces
	atf_add_test_case dashes
	atf_add_test_case quotes
	atf_add_test_case special
}
