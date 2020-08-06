#!/usr/bin/env bash

#set -Eeo pipefail
# TODO swap to -Eeuo pipefail above (after handling all potentially-unset variables)
set -x

initd="./init.d/"


if [ "${1:0:1}" = '-' ]; then

	echo set -- bash -c "$@"
	set -- bash -c "$@"

fi

# allow the container to be started with `--user`
if [ "${1}" =  "--user" ] && [ "$(id -u)" = '0' ] && [ gosu --version 2&1> /dev/null ]; then

    echo gosu $1 "$BASH_SOURCE" "$@"
    gosu $1 "$BASH_SOURCE" "$@"

fi

# allow the scripts from pseudo init directory
if [ -d "$initd" ]; then
    for f in $initd/*; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo "$0: running $f"
                    "$f"
                else
                    echo "$0: sourcing $f"
                    . "$f"
                fi
                ;;
            *)
                echo "$0: ignoring $f"
                ;;
        esac
    done
fi

set | grep TEST

echo exec "$@"
