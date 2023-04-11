#!/usr/bin/env bash
#See https://docs.gitlab.com/runner/executors/custom.html#config

cat << EOS
{
  "driver": {
    "name": "Singularity (SLURM) driver",
    "version": "v0.0.1"
  }
}
EOS