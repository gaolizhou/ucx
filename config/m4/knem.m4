#
# Check for KNEM support
#
knem_happy="no"
AC_ARG_WITH([knem],
           [AS_HELP_STRING([--with-knem=(DIR)], [Enable the use of KNEM (default is guess).])],
           [], [with_knem=guess])

AS_IF([test "x$with_knem" != xno],
    [AS_IF([test "x$with_knem" == xguess -o "x$with_knem" == xyes -o "x$with_knem" == x],
           [AC_MSG_NOTICE([KNEM path was not found, guessing ...])
            ucx_check_knem_include_dir=$(pkg-config --cflags knem)],
           [ucx_check_knem_include_dir=-I$with_knem/include])

     save_CPPFLAGS="$CPPFLAGS"

     CPPFLAGS="$ucx_check_knem_include_dir $CPPFLAGS"

     AC_CHECK_DECL([KNEM_CMD_GET_INFO],
                   [BASE_CFLAGS="$BASE_CFLAGS $ucx_check_knem_include_dir"
                    BASE_CPPFLAGS="$BASE_CPPFLAGS $ucx_check_knem_include_dir"
                    AC_DEFINE([HAVE_KNEM], [1], [Enable the use of KNEM])
                    transports="${transports},knem"
                    knem_happy="yes"],
                   [AS_IF([test "x$with_knem" != xguess],
                          [AC_MSG_ERROR([KNEM requested but required file (knem_io.h) could not be found])
                           AC_DEFINE([HAVE_KNEM], [0], [Disable the use of KNEM])],
                          [AC_MSG_WARN([KNEM requested but required file (knem_io.h) could not be found])])], 
                   [[#include <knem_io.h>]])

     CPPFLAGS="$save_CPPFLAGS"

    ],
    [AC_MSG_WARN([KNEM was explicitly disabled])
     AC_DEFINE([HAVE_KNEM], [0], [Disable the use of KNEM])]
)

AM_CONDITIONAL([HAVE_KNEM], [test "x$knem_happy" != xno])
