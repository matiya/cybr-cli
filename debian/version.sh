#!/bin/bash

main() {
    # The version of the package
    curr=$(awk -F'[[:blank:],]' '/Version/ {print $2}' DEBIAN/control)
    # Parse the version number out of the package version
    ver=$(echo "$curr" | awk -F'-' '{print $1}')
    # Parse the release number out of the package version
    rel=$(echo "$curr" | awk -F'-' '{print $2}')
    # Bump the version
    new="$ver-"$((rel+1))
    # Replace the version in the control file
    sed -i "s/^Version:.*/Version: $new/" DEBIAN/control
    # Report the old and new version
    echo "Bumped version from $curr to $new"
}

main "$@"