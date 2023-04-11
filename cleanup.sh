#!/usr/bin/env bash
#See https://docs.gitlab.com/runner/executors/custom.html#cleanup

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base.sh # Get variables from base.