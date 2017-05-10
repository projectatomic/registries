#!/bin/sh
set -e

if ! (autoreconf --version >/dev/null 2>&1); then
        echo "*** No autoreconf found, please install it ***"
        exit 1
fi

mkdir -p m4

autoreconf --force --install --verbose
