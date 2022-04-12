#!/bin/bash

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

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
    sed -i "" "s/^Version:.*/Version: ${new}/" DEBIAN/control
    # Report the old and new version
    echo -e "Bumped version from ${GREEN}${curr}${NC} to ${GREEN}${new}${NC}"
    # Add the new version to the changelog
    git add DEBIAN/control
    # Commit the change
    git commit -S -m "Bumped version from ${curr} to ${new}"
    # Push the changes
    git push -u origin secure-supply-chain
    echo -e "Pushed changes to ${YELLOW}origin/secure-supply-chain${NC} at ${CYAN}https://github.com/infamousjoeg/cybr-cli/tree/secure-supply-chain${NC}"
    echo -e "View the Jenkins pipeline at ${CYAN}https://jenkins.cybr.rocks:8443/job/cybr-cli/${NC}"
}

main "$@"