AC_INIT([registries], [0.1])
AC_CONFIG_HEADER([config.h])
AC_CONFIG_SRCDIR([registries.c])

AC_CONFIG_AUX_DIR([build])

AM_INIT_AUTOMAKE([-Wall -Werror foreign])

# Check for C compiler
AC_PROG_CC
AC_CONFIG_FILES([Makefile])

PKG_PROG_PKG_CONFIG
PKG_CHECK_MODULES([REGISTRIES_DEPS], [gio-2.0 json-glib-1.0 yaml-0.1])
AC_CHECK_PROG(GO_MD2MAN_CHECK,go-md2man,yes)
if test x"$GO_MD2MAN_CHECK" != x"yes" ; then
    AC_MSG_ERROR([Please install go-md2man.])
fi
AC_OUTPUT
