#!/bin/bash -
#title       : shell.sh
#description : husk of a shell script
#==============================================================================

set -o errexit
set -o nounset
set -o pipefail
# set -x

sbin_dir=$(dirname "${BASH_SOURCE}")
source ${sbin_dir}/utils.sh 

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
  # flag with argument
  -f|--flag)
  FLAG_VALUE="$2"
  shift
  ;;
  -h|--help)
  SCRIPT_HELP=true
  ;;
  *)
  SCRIPT_HELP=true
  ;;
esac
shift # past argument or value
done

# -h | --help
if [ -n "${SCRIPT_HELP+x}" ]; then
  show_help
  exit 0
fi

# required flag argument
if [ -z "${FLAG_VALUE+x}" ]; then
  show_help
  exit 1
fi
