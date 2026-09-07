#!/bin/bash

while [ $# -gt 0 ]; do
    case $1 in
        -c) shift; exec /bin/bash -c "$1" ;;
        -s) shift ;;
    esac
    shift
done

echo "su-as-self: no -c <command> given" >&2
exit 1