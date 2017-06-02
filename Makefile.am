include Makefile-docs.am
libexec_PROGRAMS = registries
registries_SOURCES = registries.c
registries_CFLAGS = $(REGISTRIES_DEPS_CFLAGS)
registries_CFLAGS += -pipe \
		     -Wall \
		     -Werror=empty-body \
		     -Werror=implicit-function-declaration \
		     -Werror=format=2 -Werror=format-security -Werror=format-nonliteral \
		     -Werror=pointer-arith -Werror=init-self \
		     -Werror=return-type \
		     -Werror=overflow \
		     -Werror=int-conversion \
		     -Werror=incompatible-pointer-types \
		     -Werror=misleading-indentation \
		     -Werror=missing-include-dirs -Werror=aggregate-return \
		     -Wextra \
		     -Werror=unused-result
registries_LDADD = $(REGISTRIES_DEPS_LIBS)
TESTS = test/test.sh


