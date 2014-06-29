#!/bin/sh

Prog_Name=${0##*/}

. /usr/share/atf/atf.header.subr

. ../shx_string.sh

escape_check ()
{
	res=`shx_escape "$1"`
	if [ "$res" != "$2" ]; then
		atf_fail "'$res' != '$2'"
	fi
}

atf_test_case basic
basic_head ()
{
	atf_set  "descr"  "Test basic escape sequences"
}
basic_body ()
{
	escape_check 'foobar'		'foobar'
	escape_check 'a.dot'		'a.dot'
	escape_check 'a,comma'		'a,comma'
	escape_check 'no.escape.ok'	'no.escape.ok'
}

atf_test_case spaces
spaces_head ()
{
	atf_set  "descr"  "Test escape strings with white spaces and tabs"
}
spaces_body ()
{
	# Blank spaces
	escape_check 'foo bar'		'foo\ bar'
	escape_check ' '		'\ '
	escape_check '   '		'\ \ \ '
}

atf_test_case dashes
dashes_head ()
{
	atf_set  "descr"  "Test escape strings with dashes for arguments"
}
dashes_body ()
{
	# Dashes
	escape_check '-n'		'-n'
	escape_check '-e'		'-e'
	escape_check '-e -n'		'-e\ -n'
	escape_check '-x'		'-x'
	escape_check '-v'		'-v'
	escape_check '-n a b -c'	'-n\ a\ b\ -c'
	escape_check '-e -- -c'		'-e\ --\ -c'
	escape_check '-- -e'		'--\ -e'
}

atf_test_case quotes
quotes_head ()
{
	atf_set  "descr"  "Test escape strings with simple and double quotes"
}
quotes_body ()
{
	# Simple quotes
	escape_check "'"		"\'"
	escape_check \'			\\\'
	# Double quotes
	escape_check '"'		'\"'
	escape_check \"			\\\"
}

atf_test_case special
special_head ()
{
	atf_set  "descr"  "Test escape strings other chars that need escaping"
}
special_body ()
{
	# Basic checking
	escape_check '!'		'\!'
	escape_check '#'		'\#'
	escape_check '$'		'\$'
	escape_check '&'		'\&'
	escape_check '*'		'\*'
	escape_check '&'		'\&'
	escape_check '('		'\('
	escape_check ')'		'\)'
	escape_check '['		'\['
	escape_check ']'		'\]'
	escape_check '`'		'\`'
	escape_check '<'		'\<'
	escape_check '>'		'\>'
	escape_check '?'		'\?'
	escape_check '\\'		'\\\\'

	# Complex checking
	escape_check 'foo(bar)'		'foo\(bar\)'
	escape_check '(()))('		'\(\(\)\)\)\('
	escape_check 'foo[bar]'		'foo\[bar\]'
	escape_check '[][[]][['		'\[\]\[\[\]\]\[\['
	escape_check '<><>@&6-'		'\<\>\<\>@\&6-'
	escape_check '*abc*& '		'\*abc\*\&\ '
	escape_check ' ? a $ '		'\ \?\ a\ \$\ '
	escape_check '\ <\ )$\\'	'\\\ \<\\\ \)\$\\\\'
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
