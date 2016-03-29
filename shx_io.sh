#!/bin/sh

# We do not use echo, but printf, which is more secure, since echo handles
# escape characters and dashes in a way difficult to make sure it will always
# work.  Check http://www.dwheeler.com/essays/filenames-in-shell.html for more
# information.
shx_echo ()
{
	printf '%s' "$*"
}

# shx_echo with new line at the end.
shx_echoln ()
{
	printf '%s\n' "$*"
}

# shx_echo to stderr.
shx_warn ()
{
	shx_echo "$*" >&2
}

# shx_echoln to stderr.
shx_warnln ()
{
	shx_echoln "$*" >&2
}

# shx_warn to stderr and exit.
shx_fatal ()
{
	local err
	err="$1"
	shift
	shx_warn "$*" >&2
	shx_exit "$err"
}

# shx_warnln to stderr and exit.
shx_fatalln ()
{
	local err
	err="$1"
	shift
	shx_warnln "$*" >&2
	shx_exit "$err"
}

# Print with colors
#
# $1 -> Color specs
# $2 -> The text.
#
# Example:
#
#     shx_echo_color "FG_BLUE BG_YELLOW BOLD" "color this text"
shx_echo_color ()
{
	printf "$(shx_priv_mount_color_code "$1")"
	shx_echo "$2"
	printf $shx_RESET
}

# Print with colors and a new line.
#
# $1 -> Color specs
# $2 -> The text.
#
# Example:
#
#     shx_echoln_color "FG_BLUE BG_YELLOW BOLD" "color this text"
shx_echoln_color ()
{
	shx_echo_color "$1" "$2"
	shx_echoln ""
}


# Build the color string to tell to the terminal.
# $1 -> List of color rules.  They are the constant names in shx_consts.sh
#       without the "shx_" prefix.
#
# Example:
#
#     shx_priv_mount_color_code "FG_BLUE BG_YELLOW BOLD"
shx_priv_mount_color_code ()
{
	local color=
	local c
	for c in $@; do
		test -n "$color" && color="${color};"
		c="$(eval "shx_echo \$shx_${c}")"
		color="${color}${c}"
		
	done
	shx_echo "\e[${color}m"
}
