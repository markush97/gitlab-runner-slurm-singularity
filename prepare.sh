#!/usr/bin/env bash
# https://docs.gitlab.com/runner/executors/custom.html#prepare

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base.sh # Get variables from base.

#set -eo pipefail

# trap any error, and mark it as a system failure.
trap "exit $SYSTEM_FAILURE_EXIT_CODE" ERR


echo "Building singularity image from dockerimage"
# Prepare singularity image
#singularity build test.img docker://"${CUSTOM_ENV_CI_JOB_IMAGE}"

echo "Done building!"

lines=$(singularity instance list "$CONTAINER_ID" | wc -l)
if [[ $lines -ne 2 ]]; then
    echo 'Found old running instance, stopping'
    singularity instance stop "$CONTAINER_ID"
fi

echo "Starting singularity instance"

singularity instance start -H ${currentDir} -B /cvmfs:cvmfs /tmp/test.img "$CONTAINER_ID"

echo "Waiting for container to start"

for i in $(seq 1 10); do
    singularity exec instance://"$CONTAINER_ID" cat /etc/os-release >/dev/null 2>/dev/null
    if [[ $? -eq 0 ]]; then
        break
    fi

    if [ "$i" == "10" ]; then
        echo 'Waited for 10 seconds to start container, exiting..'
        # Inform GitLab Runner that this is a system failure, so it
        # should be retried.
        exit "$SYSTEM_FAILURE_EXIT_CODE"
    fi

    sleep 1s
done

echo "Running container with id $CONTAINER_ID"