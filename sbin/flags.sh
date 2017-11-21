#!/bin/bash -
#title       : flags.sh
#description : testing shell expansions
#==============================================================================

set -o errexit
set -o nounset
set -o pipefail
# set -x

sbin_dir=$(dirname "${BASH_SOURCE}")
source ${sbin_dir}/utils.sh 

function show_help {
  inf "Usage: \n"
  inf "flags.sh [flags] \n"
  inf "Flags are:"
  inf "  -a|--aflag     - Intialized optional flag   (no arg)"
  inf "  -b|--bflag     - Unintialized optional flag (no arg)"
  inf "  -c|--cflag     - Intialized required flag   (no arg)"
  inf "  -d|--dflag     - Unintialized required flag (no arg)"
  inf "  -e|--eflag arg - Intialized optional flag   (w/ arg)"
  inf "  -f|--flag arg  - Unintialized optional flag (w/ arg)"
  inf "  -g|--gflag arg - Intialized required flag   (w/ arg)"
  inf "  -i|--ilag arg  - Unintialized required flag (w/ arg)"
  inf "  -h|--help      - Show this help\n"
  inf "Example:"
  inf "  flags.sh --flag argument"
}

AFLAG=false
CFLAG=false
EFLAG_ARG=init
GFLAG_ARG=init

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
  # a: initalized optional flag with no argument
  -a|--aflag)
  AFLAG=true
  ;;
  # b: uninitialized optional flag with no argument
  -b|--bflag)
  BFLAG=true
  ;;
  # c: initalized required flag with no argument
  -c|--cflag)
  CFLAG=true
  ;;
  # d: uninitialized required flag with no argument
  -d|--dflag)
  DFLAG=true
  ;;
  # e: initialzied optional flag with argument
  -e|--eflag)
  EFLAG_ARG="$2"
  shift
  ;;
  # f: uninitialzied optional flag with argument
  -f|--flag)
  FLAG_ARG="$2"
  shift
  ;;
  # g: initialzied required flag with argument
  -g|--gflag)
  GFLAG_ARG="$2"
  shift
  ;;
  # i: uninitialzied required flag with argument
  -i|--iflag)
  IFLAG_ARG="$2"
  shift
  ;;
  -h|--help)
  HELP=true
  ;;
  *)
  HELP=true
  ;;
esac
shift # past argument or value
done

# Expansion Semantics:
# - http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
# Test Operands: 
# - http://pubs.opengroup.org/onlinepubs/9699919799/utilities/test.html#tag_20_128_05

# -h | --help
if [ -n "${HELP+x}" ]; then
  show_help
  exit 0
fi

# a: initalized optional flag with no argument
if [ -z "${AFLAG:+x}" ]; then  
  warn "a: null/unset/empty initialized optional flag with noargument: AFLAG"
else
  inf "a: initialized optional flag with no argument: ${AFLAG}"
fi

# b: uninitialized optional flag with no argument
if [ -z "${BFLAG:+x}" ]; then
  warn "b: null/unset/empty uninitialized optional flag with no argument: BFLAG"
else
  inf "b: uninitialized optional flag with no argument: ${BFLAG}"
fi

# c: initalized required flag with no argument
if [ -z "${CFLAG:+x}" ]; then
  error "c: null/unset/empty initalized required flag with no argument: CFLAG"
  exit 1
else
  inf "c: initalized required flag with no argument: ${CFLAG}"
fi

# d: uninitialized required flag with no argument
if [ -z "${DFLAG:+x}" ]; then
  error "d: null/unset/empty uninitialized required flag with no argument: DFLAG"
  exit 1
else
  inf "d: uninitialized required flag with no argument: ${DFLAG}"
fi

# e: initialzied optional flag with argument
if [ -z "${EFLAG_ARG+x}" ]; then
  warn "e: null/unset/empty initialzied optional flag with argument: EFLAG_ARG"
else
  inf "e: initialzied optional flag with argument ${EFLAG_ARG}"
fi

# f: uninitialzied optional flag with argument
if [ -z "${FLAG_ARG:+x}" ]; then
  warn "f: null/unset/empty uninitialzied optional flag with argument: FLAG_ARG"
else
  inf "f: uninitialzied optional flag with argument: ${FLAG_ARG}"
fi

# g: initialzied required flag with argument
if [ -z "${GFLAG_ARG:+x}" ]; then
  error "g: null/unset/empty initialzied required flag with argument: GFLAG_ARG"
  exit 1
else
  inf "g: initialzied required flag with argument: ${GFLAG_ARG}"
fi

# i: uninitialzied required flag with argument
if [ -z "${IFLAG_ARG:+x}" ]; then
  error "i: null/unset/empty uninitialzied required flag with argument: IFLAG_ARG"
  exit 1
else
  inf "i: uninitialzied required flag with argument: ${IFLAG_ARG}"
fi

