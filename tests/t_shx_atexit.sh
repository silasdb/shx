#!/bin/sh

Prog_Name=${0##*/}

. /usr/share/atf/atf.header.subr

. ../shx_atexit.sh

mocks_file_1='mocks/file with space'
mocks_file_2='mocks/another file with -a -b -c -d -e -- dashes'
mocks_file_3='mocks/-x -start with dash and have spaces'
mocks_file_4='mocks/simple_file'
mocks_file_create ()
{
	mkdir -p mocks
	touch "$mocks_file_1"
	touch "$mocks_file_2"
	touch "$mocks_file_3"
	touch "$mocks_file_4"
}
mocks_file_all_exist ()
{
	test -f "$mocks_file_1" || return 1
	test -f "$mocks_file_2" || return 1
	test -f "$mocks_file_3" || return 1
	test -f "$mocks_file_4" || return 1
	return 0
}
mocks_file_some_exist ()
{
	test -f "$mocks_file_1" && return 0
	test -f "$mocks_file_2" && return 0
	test -f "$mocks_file_3" && return 0
	test -f "$mocks_file_4" && return 0
	return 1
}

mocks_dir_1='mocks/dir with space'
mocks_dir_2='mocks/another dir with -a -b -c -d -e -- dashes'
mocks_dir_3='mocks/-x -start with dash and have spaces'
mocks_dir_4='mocks/simple_dir'
mocks_dir_create ()
{
	mkdir -p mocks
	mkdir -p "$mocks_dir_1"
	mkdir -p "$mocks_dir_2"
	mkdir -p "$mocks_dir_3"
	mkdir -p "$mocks_dir_4"
	# Create files
	touch "$mocks_dir_1/a"
	touch "$mocks_dir_1/b b"
	touch "$mocks_dir_1/c"
	touch "$mocks_dir_2/a"
	touch "$mocks_dir_2/b b"
	touch "$mocks_dir_2/c"
	touch "$mocks_dir_3/a"
	touch "$mocks_dir_3/b b"
	touch "$mocks_dir_3/c"
	touch "$mocks_dir_4/a"
	touch "$mocks_dir_4/b b"
	touch "$mocks_dir_4/c"
}
mocks_dir_all_exist ()
{
	test -d "$mocks_dir_1" || return 1
	test -d "$mocks_dir_2" || return 1
	test -d "$mocks_dir_3" || return 1
	test -d "$mocks_dir_4" || return 1
	return 0
}
mocks_dir_some_exist ()
{
	test -d "$mocks_dir_1" && return 0
	test -d "$mocks_dir_2" && return 0
	test -d "$mocks_dir_3" && return 0
	test -d "$mocks_dir_4" && return 0
	return 1
}


atf_test_case rmfile
rmfile_head ()
{
	atf_set  "descr"  "Remove files"
}
rmfile_body ()
{
	mocks_file_create
	shx_atexit_rm "$mocks_file_1"
	shx_atexit_rm "$mocks_file_2"
	shx_atexit_rm "$mocks_file_3"
	shx_atexit_rm "$mocks_file_4"
	shx_atexit_rm_enqueued_files
	mocks_file_all_exist \
	    && atf_fail "All files still exist after calling shx_atexit_rm_enqueued_files"
	mocks_file_some_exist \
	    && atf_fail "Some files still exist after calling shx_atexit_rm_enqueued_files"
	atf_pass
}

atf_test_case rmdir
rmdir_head ()
{
	atf_set  "descr"  "Remove directories"
}
rmdir_body ()
{
	mocks_dir_create
	shx_atexit_rm "$mocks_dir_1"
	shx_atexit_rm "$mocks_dir_2"
	shx_atexit_rm "$mocks_dir_3"
	shx_atexit_rm "$mocks_dir_4"
	shx_atexit_rm_enqueued_files
	mocks_dir_all_exist \
	    && atf_fail "All dirs still exist after calling shx_atexit_rm_enqueued_files"
	mocks_dir_some_exist \
	    && atf_fail "Some dirs still exist after calling shx_atexit_rm_enqueued_files"
	atf_pass
}

atf_init_test_cases ()
{
	atf_add_test_case rmfile
	atf_add_test_case rmdir
}

. /usr/share/atf/atf.footer.subr

main "$@"
