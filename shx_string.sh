#!/bin/sh

shx_string_loaded="yes"

shx_priv_e=

# Escapes a string so the shell can handle it.
shx_escape ()
{
	shx_priv_e="$*"

	# This must be before everything else
	shx_priv_add_backslash '\\'

	shx_priv_add_backslash ' '
	shx_priv_add_backslash '!'
	shx_priv_add_backslash '#'
	shx_priv_add_backslash '\$'
	shx_priv_add_backslash '&'
	shx_priv_add_backslash '*'
	shx_priv_add_backslash '('
	shx_priv_add_backslash ')'
	shx_priv_add_backslash '\['
	shx_priv_add_backslash '\]'
	shx_priv_add_backslash '`'
	shx_priv_add_backslash '<'
	shx_priv_add_backslash '>'
	shx_priv_add_backslash '?'
	shx_priv_add_backslash "'"
	shx_priv_add_backslash '"'
	shx_priv_add_backslash ';'
	printf '%s' "$shx_priv_e"
}

shx_priv_add_backslash ()
{
	shx_priv_e=$(shx_echo "$shx_priv_e" | sed "s/$1/\\\\$1/g")
}
