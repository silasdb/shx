#!/usr/bin/env atf-sh

SHX_HOME="$(pkg-config --variable=prefix shx)"

# Creates and executes the script.
# $1 -> name.
# $2 -> Expectation ("pass" or "fail")
# The contents of the script should be passed via stdin
test_script ()
{
	mkdir -p mocks
	name="$1"
	file="$(mktemp "mocks/test.${name}.sh")"
	# Headerof the script.
	cat >> "$file"
	if [ "$2" = "pass" ]; then
		sh "$file" || atf_fail "Script '$name' failed."
	else
		sh "$file" && atf_fail "Script '$name' should fail!"
		return 0
	fi
}

quirk_unset_head ()
{
	atf_set 'descr'  'Test the quirk_unset quirk'
}
quirk_unset_body ()
{
	test_script quirk_unset_1 pass <<-EOF
		#!/bin/sh
		SHX_HOME="$SHX_HOME"
		. $SHX_HOME/shx.sh
		main () { }
		shx_init "\$@"
	EOF
	test_script quirk_unset_2 pass <<-EOF
		#!/bin/sh
		SHX_HOME="$SHX_HOME"
		. $SHX_HOME/shx.sh
		main () { }
		shx_init "\$*"
	EOF

	test_script quirk_unset_3 pass <<-EOF
		#!/bin/sh
		set -e
		set -u
		SHX_HOME="$SHX_HOME"
		. $SHX_HOME/shx_quirks.sh
		if (set -u; echo "\$@") then
			test \$shx_quirk_unset = no
			test \$shx_using_quirks = no
		else
			test \$shx_quirk_unset = yes
			test \$shx_using_quirks = yes
		fi
	EOF
}

atf_init_test_cases ()
{
	atf_add_test_case quirk_unset
}
