#!/usr/bin/env atf-sh

. "$(pkg-config --variable=prefix shx)"/shx_system.sh

md5file_check ()
{
	local a
	local b
	a="$(md5 -n "$1" | awk '{ print $1; }')"
	b="$(shx_md5 "$1")"

	if [ "$a" != "$b" ]; then
		atf_fail "$a != $b"
	fi
}

md5stdin_check ()
{
	local a
	local b
	a="$(md5 -n "$1" | awk '{ print $1; }')"
	b="$(cat "$1" | shx_md5)"

	if [ "$a" != "$b" ]; then
		atf_fail "$a != $b"
	fi
}

atf_test_case md5
md5_head ()
{
	atf_set  "descr"  "Test shx_md5 function"
}
md5_body ()
{
	md5file_check '/etc/fstab'
}

# TODO: add a test for md5 via stdin

atf_init_test_cases ()
{
	atf_add_test_case md5
}
