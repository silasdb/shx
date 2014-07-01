#!/bin/sh

Prog_Name=${0##*/}

. /usr/share/atf/atf.header.subr

. ../shx_atexit.sh
. ../shx_io.sh
. ../shx_string.sh

mocks_file_1='mocks/file with space'
mocks_file_2='mocks/another file with -a -b -c -d -e -- dashes'
mocks_file_3='mocks/-x -start with dash and have spaces'
mocks_file_4='mocks/simple_file'
mocks_files_create ()
{
	mkdir -p mocks
	touch "$mocks_file_1"
	touch "$mocks_file_2"
	touch "$mocks_file_3"
	touch "$mocks_file_4"
}
mocks_files_all_exist ()
{
	# If one file doesn't exit, return 1.
	test -f "$mocks_file_1" || return 1
	test -f "$mocks_file_2" || return 1
	test -f "$mocks_file_3" || return 1
	test -f "$mocks_file_4" || return 1
	return 0
}
mocks_files_some_exist ()
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
mocks_dirs_create ()
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
mocks_dirs_all_exist ()
{
	test -d "$mocks_dir_1" || return 1
	test -d "$mocks_dir_2" || return 1
	test -d "$mocks_dir_3" || return 1
	test -d "$mocks_dir_4" || return 1
	return 0
}
mocks_dirs_some_exist ()
{
	test -d "$mocks_dir_1" && return 0
	test -d "$mocks_dir_2" && return 0
	test -d "$mocks_dir_3" && return 0
	test -d "$mocks_dir_4" && return 0
	return 1
}


atf_test_case rmfiles
rmfiles_head ()
{
	atf_set  "descr"  "Remove files"
}
rmfiles_body ()
{
	mocks_files_create
	shx_atexit_rm "$mocks_file_1"
	shx_atexit_rm "$mocks_file_2"
	shx_atexit_rm "$mocks_file_3"
	shx_atexit_rm "$mocks_file_4"
	shx_atexit_rm_enqueued_files
	mocks_files_all_exist \
	    && atf_fail "All files still exist after calling shx_atexit_rm_enqueued_files"
	mocks_files_some_exist \
	    && atf_fail "Some files still exist after calling shx_atexit_rm_enqueued_files"
}

atf_test_case rmdirs
rmdirs_head ()
{
	atf_set  "descr"  "Remove directories"
}
rmdirs_body ()
{
	mocks_dirs_create
	shx_atexit_rm "$mocks_dir_1"
	shx_atexit_rm "$mocks_dir_2"
	shx_atexit_rm "$mocks_dir_3"
	shx_atexit_rm "$mocks_dir_4"
	shx_atexit_rm_enqueued_files
	mocks_dir_all_exist \
	    && atf_fail "All dirs still exist after calling shx_atexit_rm_enqueued_files"
	mocks_dir_some_exist \
	    && atf_fail "Some dirs still exist after calling shx_atexit_rm_enqueued_files"
}

atf_test_case rm_one_file
rm_one_file_head ()
{
	atf_set "descr" "Try to remove only one file"
	# This test is necessary because, inside shx_atexit.sh, we make a
	# subtraction with expr(1).  When we had only one file, the subtraction
	# was 1 - 1 = 0.  When this happens, expr exits with status 1 (see its
	# man page) which made the program halt.  Now we use $((...)) instead of
	# expr.
}
rm_one_file_body ()
{
	mkdir -p "mocks"
	touch "mocks/onefile"
	shx_atexit_rm "mocks/onefile"
	shx_atexit_rm_enqueued_files
	test -f "mocks/onefile" && atf_fail "mocks/onefile still exists!"
}

atf_init_test_cases ()
{
	atf_add_test_case rmfiles
	atf_add_test_case rmdirs
	atf_add_test_case rm_one_file
}

. /usr/share/atf/atf.footer.subr

main "$@"
