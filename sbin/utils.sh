#!/bin/bash -
#title       : utils.sh
#description : shell script utilities
#==============================================================================

function inf {
  echo -e "\033[0;32m$1\033[0m"
}

function warn {
  echo -e "\033[1;33mWARNING: $1\033[0m"
}

function error {
  echo -e "\033[0;31mERROR: $1\033[0m"
}

function run_command {
  inf "Running: $1"
  eval $1
}
