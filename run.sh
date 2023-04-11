#!/usr/bin/env bash
#See https://docs.gitlab.com/runner/executors/custom.html#run

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base.sh # Get variables from base.

#singularity exec instance://"$CONTAINER_ID" /bin/bash < "${1}"
echo ${1}
cat ${1}
singularity exec instance://testid /bin/bash < "${1}"
if [ $? -ne 0 ]; then
    # Exit using the variable, to make the build as failure in GitLab
    # CI.
    exit "$BUILD_FAILURE_EXIT_CODE"
fi