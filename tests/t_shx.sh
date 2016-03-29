#!/usr/bin/env atf-sh

SHX_HOME="$(pkg-config --variable=prefix shx)"

# Creates and executes the script.  It creates the header.
# $1 -> name.
# $2 -> Expectation ("pass" or "fail")
# The contents of the script should be passed via stdin
test_script ()
{
	mkdir -p mocks
	name="$1"
	file="$(mktemp "mocks/test.${name}.sh")"
	# Headerof the script.
	cat > "$file" <<-EOF
		#!/bin/sh
		SHX_HOME="$SHX_HOME"
		. $SHX_HOME/shx.sh
	EOF
	cat >> "$file"
	cp "$file" /tmp/xxx
	if [ "$2" = "pass" ]; then
		sh "$file" || atf_fail "Script '$name' failed."
	else
		sh "$file" && atf_fail "Script '$name' should fail!"
		return 0
	fi
}

atf_test_case basics
basics_head ()
{
	atf_set  "descr"  "Test shx basic functionality"
}
basics_body ()
{
	test_script require1 pass <<-EOF
		shx_require io
	EOF
	test_script require2 fail <<-EOF
		shx_require foo
	EOF
	test_script require3 pass <<-EOF
		shx_require string io atexit
		shx_require string io
	EOF
	test_script require4 fail <<-EOF
		shx_require atexit
		shx_priv_module_loaded log
	EOF
	test_script require5 pass <<-EOF
		shx_require atexit
		shx_priv_module_loaded atexit
	EOF
}

atf_init_test_cases ()
{
	atf_add_test_case basics
}
