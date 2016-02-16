#!/bin/sh
#
# Workarounds to deal with different shell quirks

shx_using_quirks=no

# Some shells (like /bin/sh in NetBSD < 7.0) consider an error to have "$@" and
# "$*" unset if "set -u" is provided.  Test if this happens and, if so, disable
# set -u (set +u).
#
# See the following link for details:
# http://gnats.netbsd.org/cgi-bin/query-pr-single.pl?number=48202
shx_quirk_unset=no
(set --; set -u; test "${#@}" -ge 0) 2>/dev/null || {
	set +u
	shx_quirk_unset=yes
	shx_using_quirks=yes
}
