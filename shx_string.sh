#!/bin/sh

shx_string_loaded="yes"

shx_priv_e=

# Escapes a string so the shell can handle it without quotes.
shx_escape ()
{
	local old_opts
	old_opts="$(set +o)"
	set +x
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
	eval "$old_opts" 2>/dev/null
}

shx_priv_add_backslash ()
{
	shx_priv_e=$(shx_echo "$shx_priv_e" | sed "s/$1/\\\\$1/g")
}
