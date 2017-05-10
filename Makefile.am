include Makefile-docs.am
bin_PROGRAMS = registries
registries_SOURCES = registries.c
registries_CFLAGS = $(REGISTRIES_DEPS_CFLAGS)
registries_LDADD = $(REGISTRIES_DEPS_LIBS)
#AM_TESTS_ENVIRONMENT = sh ./test/test.sh
TESTS = test/test.sh
