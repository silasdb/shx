#!/usr/bin/env atf-sh

. "$(pkg-config --variable=prefix shx)"/shx_atexit.sh
. "$(pkg-config --variable=prefix shx)"/shx_io.sh
. "$(pkg-config --variable=prefix shx)"/shx_string.sh

mocks_file_1='file with space'
mocks_file_2='another file with -a -b -c -d -e -- dashes'
mocks_file_3='-x -start with dash and have spaces'
mocks_file_4='simple_file'
mocks_file_5='file with ; semicolon ; echo x'
mocks_file_6='file with "doublequote" ; echo x'
mocks_file_7="file with 'single quote' ; echo x"
mocks_file_8='-i -start with dash and have spaces'
mocks_files_create ()
{
	mkdir -p mocks
	touch "mocks/$mocks_file_1"
	touch "mocks/$mocks_file_2"
	touch "mocks/$mocks_file_3"
	touch "mocks/$mocks_file_4"
	touch "mocks/$mocks_file_5"
	touch "mocks/$mocks_file_6"
	touch "mocks/$mocks_file_7"
	touch "mocks/$mocks_file_8"
}
mocks_files_all_exist ()
{
	# If one file doesn't exit, return 1.
	test -f "mocks/$mocks_file_1" || return 1
	test -f "mocks/$mocks_file_2" || return 1
	test -f "mocks/$mocks_file_3" || return 1
	test -f "mocks/$mocks_file_4" || return 1
	test -f "mocks/$mocks_file_5" || return 1
	test -f "mocks/$mocks_file_6" || return 1
	test -f "mocks/$mocks_file_7" || return 1
	test -f "mocks/$mocks_file_8" || return 1
	return 0
}
mocks_files_some_exist ()
{
	test -f "mocks/$mocks_file_1" && return 0
	test -f "mocks/$mocks_file_2" && return 0
	test -f "mocks/$mocks_file_3" && return 0
	test -f "mocks/$mocks_file_4" && return 0
	test -f "mocks/$mocks_file_5" && return 0
	test -f "mocks/$mocks_file_6" && return 0
	test -f "mocks/$mocks_file_7" && return 0
	test -f "mocks/$mocks_file_8" && return 0
	return 1
}

mocks_dir_1='dir with space'
mocks_dir_2='another dir with -a -b -c -d -e -- dashes'
mocks_dir_3='-x -start with dash and have spaces'
mocks_dir_4='simple_dir'
mocks_dir_5='-i -start with dash and have spaces'
mocks_dirs_create ()
{
	mkdir -p mocks
	mkdir -p "mocks/$mocks_dir_1"
	mkdir -p "mocks/$mocks_dir_2"
	mkdir -p "mocks/$mocks_dir_3"
	mkdir -p "mocks/$mocks_dir_5"
	# Create files
	touch "mocks/$mocks_dir_1/a"
	touch "mocks/$mocks_dir_1/b b"
	touch "mocks/$mocks_dir_1/c"
	touch "mocks/$mocks_dir_2/a"
	touch "mocks/$mocks_dir_2/b b"
	touch "mocks/$mocks_dir_2/c"
	touch "mocks/$mocks_dir_3/a"
	touch "mocks/$mocks_dir_3/b b"
	touch "mocks/$mocks_dir_3/c"
	touch "mocks/$mocks_dir_4/a"
	touch "mocks/$mocks_dir_4/b b"
	touch "mocks/$mocks_dir_4/c"
	touch "mocks/$mocks_dir_5/a"
	touch "mocks/$mocks_dir_5/b b"
	touch "mocks/$mocks_dir_5/c"
}
mocks_dirs_all_exist ()
{
	test -d "mocks/$mocks_dir_1" || return 1
	test -d "mocks/$mocks_dir_2" || return 1
	test -d "mocks/$mocks_dir_3" || return 1
	test -d "mocks/$mocks_dir_4" || return 1
	test -d "mocks/$mocks_dir_5" || return 1
	return 0
}
mocks_dirs_some_exist ()
{
	test -d "mocks/$mocks_dir_1" && return 0
	test -d "mocks/$mocks_dir_2" && return 0
	test -d "mocks/$mocks_dir_3" && return 0
	test -d "mocks/$mocks_dir_4" && return 0
	test -d "mocks/$mocks_dir_5" && return 0
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
	(
	cd mocks
	shx_atexit_rm "$mocks_file_1"
	shx_atexit_rm "$mocks_file_2"
	shx_atexit_rm "$mocks_file_3"
	shx_atexit_rm "$mocks_file_4"
	shx_atexit_rm "$mocks_file_5"
	shx_atexit_rm "$mocks_file_6"
	shx_atexit_rm "$mocks_file_7"
	shx_atexit_rm "$mocks_file_8"
	shx_atexit_rm_enqueued_files
	)
	mocks_files_all_exist \
	    && atf_fail "All files still exist after calling shx_atexit_rm_enqueued_files"
	mocks_files_some_exist \
	    && atf_fail "Some files still exist after calling shx_atexit_rm_enqueued_files"
	atf_pass
}

atf_test_case rmdirs
rmdirs_head ()
{
	atf_set  "descr"  "Remove directories"
}
rmdirs_body ()
{
	mocks_dirs_create
	(
	cd mocks
	shx_atexit_rm "$mocks_dir_1"
	shx_atexit_rm "$mocks_dir_2"
	shx_atexit_rm "$mocks_dir_3"
	shx_atexit_rm "$mocks_dir_4"
	shx_atexit_rm "$mocks_dir_5"
	shx_atexit_rm_enqueued_files
	)
	mocks_dirs_all_exist \
	    && atf_fail "All dirs still exist after calling shx_atexit_rm_enqueued_files"
	mocks_dirs_some_exist \
	    && atf_fail "Some dirs still exist after calling shx_atexit_rm_enqueued_files"
	atf_pass
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
	atf_pass
}

atf_init_test_cases ()
{
	atf_add_test_case rmfiles
	atf_add_test_case rmdirs
	atf_add_test_case rm_one_file
}
