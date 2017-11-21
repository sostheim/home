#!/bin/bash -
# title       : clone-user-repos.sh
# description : Clone all of a users repos without authenticating, subject to
#             : https://developer.github.com/v3/#rate-limiting.  Note that for
#             : unauthenticated requests, the rate limit allows for up to 60 
#             : requests per hour. 
#==============================================================================
set -o errexit
set -o nounset
set -o pipefail
# set -x

sbin_dir=$(dirname "${BASH_SOURCE}")
source ${sbin_dir}/utils.sh 

declare -i clone_count=0
declare -i exist_count=0
declare -i remaining=1
declare -i total=0
declare -i skipped=0
declare -i existing=0

DRYRUN=false 

function show_help {
  inf "Usage:"
  inf "  clone-user-repos.sh [flags]\n"
  inf "Flags:"
  inf "  -h|--help   - display this message"
  inf "  -u|--user   - Required: GitHub user's name"
  inf "  -d|--dryrun - test execution without actually cloning\n"
  inf "Example:"
  inf "  $ clone-user-repos.sh --user sostheim"
}

# Expects GitHub api v3 repo descriptior format for parsing
# [
#   {
#      . . .
#      "clone_url": "https://github.com/sostheim/repo-n.git"
#      . . .
#   },
#   . . .
# ]
function cloner {
  # $1 -> per_page <= 100 (GitHub API v3) 
  # $2 -> page index range of per_page results 1..n 
  url="https://api.github.com/users/${GITHUB_USER}/repos?per_page=$1&page=$2"
  for i in `curl -s ${url} | grep clone_url | cut -d ':' -f 2- | tr -d '",'`;
  do 
      filename=$(basename $i .git)
      exists=false
      if [ -e "${filename}" ]; then
        exists=true 
        exist_count+=1
      else
        clone_count+=1
      fi
      if [ "${DRYRUN}" = true ]; then
        if [ "${exists}" = true ]; then
          echo "dryrun: skipping $i, local file/directory: ${filename}, already exists."
        else
          echo "dryrun: git clone $i"
        fi
      else
        if [ "${exists}" = true ]; then
          echo "skipping $i, local file/directory: ${filename}, already exists."
        else
          git clone $i
        fi
      fi
      clone_count+=1
  done
}

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
  -d|--dryrun)
  DRYRUN=true
  ;;
  -u|--user)
  GITHUB_USER="$2"
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

if [ -n "${SCRIPT_HELP+x}" ]; then
  show_help
  exit 0
fi

if [ -z "${GITHUB_USER+x}" ]; then
  show_help
  exit 1
fi

# 1 .. 10: limit's results to 500 repositories
while [[ ${remaining} -gt 0 && ${remaining} -lt 11  ]]
do
    clone_count=0
    exist_count=0
    cloner 50 ${remaining}
    if [ $((${clone_count}+${exist_count})) -eq 50 ]; then
    	remaining+=1
    else
    	remaining=0
    fi

    total+=$((${clone_count} + ${exist_count}))
    cloned+=${clone_count}
    existing+=${exist_count}
done

inf "Done: repositories: ${total}, cloned: ${cloned}, existing: ${existing}"