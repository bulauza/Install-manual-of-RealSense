#!/bin/bash

red=31
yellow=33
cyan=36

colored() {
    color=$1
    shift
    echo -e "\033[1;${color}m$@\033[0m"
}


check() {
    "$@"
    result=$?
    if [ $result -ne 0 ]; then
        echo -n $(colored $red "Failed line $LINENO: ")
        echo -n $(colored $cyan "$@ ")
        echo $(colored $yellow "[$PWD]")
        exit $result
    fi
    return 0
}
