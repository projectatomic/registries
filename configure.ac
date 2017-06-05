AC_INIT([registries], [0.1])
AC_CONFIG_HEADER([config.h])
AC_CONFIG_SRCDIR([registries.c])

AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([buildutil])

AM_INIT_AUTOMAKE([1.13 -Wno-portability foreign no-define tar-ustar no-dist-gzip dist-xz
                  color-tests subdir-objects])
AC_USE_SYSTEM_EXTENSIONS
AC_SYS_LARGEFILE

# Check for C compiler
AC_PROG_CC
AM_PROG_CC_C_O

dnl The canonical version of this is in libostree
CC_CHECK_FLAGS_APPEND([WARN_CFLAGS], [CFLAGS], [\
-pipe \
-Wall \
-Werror=empty-body \
-Werror=strict-prototypes \
-Werror=missing-prototypes \
-Werror=implicit-function-declaration \
"-Werror=format=2 -Werror=format-security -Werror=format-nonliteral" \
-Werror=pointer-arith -Werror=init-self \
-Werror=missing-declarations \
-Werror=return-type \
-Werror=overflow \
-Werror=int-conversion \
-Werror=parenthesis \
-Werror=incompatible-pointer-types \
-Werror=misleading-indentation \
-Werror=missing-include-dirs -Werror=aggregate-return \
-Werror=unused-result \
])
AC_SUBST(WARN_CFLAGS)

PKG_PROG_PKG_CONFIG
PKG_CHECK_MODULES([REGISTRIES_DEPS], [gio-2.0 json-glib-1.0 yaml-0.1])
AC_CHECK_PROG(GO_MD2MAN_CHECK,go-md2man,yes)
if test x"$GO_MD2MAN_CHECK" != x"yes" ; then
    AC_MSG_ERROR([Please install go-md2man.])
fi

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
