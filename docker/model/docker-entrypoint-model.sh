#!/bin/bash

#set -Eeo pipefail
# TODO swap to -Eeuo pipefail above (after handling all potentially-unset variables)
set -x

directory="/docker-entrypoint.d"


if [ "${1:0:1}" = '-' ]; then

	echo set -- bash -c "$@"
	set -- bash -c "$@"

fi

# allow the container to be started with `--user`
if [ "${1}" =  "--user" ] && [ "$(id -u)" = '0' ] ; then
    if [ gosu --version 2&1> /dev/null ]; then

        echo gosu $1 "$BASH_SOURCE" "$@"
        gosu $1 "$BASH_SOURCE" "$@"
    else
        echo "gosu not found!
        exit 1
    fi

fi

# allow the scripts from pseudo docker-entrypoint.d directory
if [ -d "$directory" ]; then
    for f in "$directory"/* ; do
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

# exec whatever
echo exec "$@"

