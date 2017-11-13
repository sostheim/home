#!/bin/bash -
#title       : shell.sh
#description : husk of a shell script
#==============================================================================

set -o errexit
set -o nounset
set -o pipefail

# set -x

my_dir=$(dirname "${BASH_SOURCE}")

function warn {
  echo -e "\033[1;33mWARNING: $1\033[0m"
}

function error {
  echo -e "\033[0;31mERROR: $1\033[0m"
}

function inf {
  echo -e "\033[0;32m$1\033[0m"
}

function show_help {
  inf "Usage: \n"
  inf "shell.sh [flags] \n"
  inf "Flags are:"
  inf "  -f|--flag arg  - Description of a flag"
  inf "  -h|--help      - Show this help\n"
  inf "Example:"
  inf "  shell.sh --flag argument"
}

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
  -f|--flag)
  FLAG_VALUE="$2"
  shift
  -h|--help)
  SCRIPT_HELP=true
  ;;
  *)
  SCRIPT_HELP=true
  ;;
esac
shift # past argument or value
done

if [ -n "${SCRIPT_HELP+x}" ]; then
  show_help
  exit 0
fi

if [ -z "${FLAG_VALUE+x}" ]; then
  show_help
  exit 1
fi



