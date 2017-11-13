#!/bin/bash -
# title       : clone-org-repos.sh
# description : Given a user with repo scope access, clone all of an orgs repos
#==============================================================================
set -o errexit
set -o nounset
set -o pipefail
# set -x

declare -i clone_count=0
declare -i remaining=1
declare -i total=0

DRYRUN=false 

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
  inf "Usage:"
  inf "  clone-org-repos.sh [flags]\n"
  inf "Flags:"
  inf "  -h|--help   - display this message"
  inf "  -o|--org    - Required: GitHub organization name"
  inf "  -u|--user   - Required: GitHub user name"
  inf "  -t|--token  - Required: GitHub users OAuth token"
  inf "  -d|--dryrun - test execution without actually cloning\n"
  inf "Example:"
  inf "  $ clone-org-repos.sh --user sostheim --org samsung-cnct --token e72e16c7e42f292c6912e7710c838347ae178b4a"
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
  url="https://api.github.com/orgs/${GITHUB_ORG}/repos?per_page=$1&page=$2"
  for i in `curl -sH "Authorization: token ${GITHUB_OAUTH}" ${url} | grep clone_url | cut -d ':' -f 2- | cut -d '/' -f 3- | tr -d '",'`;
  do 
      if [ "${DRYRUN}" = true ]; then
        echo "dryrun: git clone https://${GITHUB_USER}:${GITHUB_OAUTH}@$i"
      else
	      git clone https://${GITHUB_USER}:${GITHUB_OAUTH}@$i
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
  -o|--org)
  GITHUB_ORG="$2"
  shift
  ;;
  -u|--user)
  GITHUB_USER="$2"
  shift
  ;;
  -t|--token)
  GITHUB_OAUTH="$2"
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

if [ -z "${GITHUB_ORG+x}" ]; then
  show_help
  exit 1
fi

if [ -z "${GITHUB_USER+x}" ]; then
  show_help
  exit 1
fi

if [ -z "${GITHUB_OAUTH+x}" ]; then
  show_help
  exit 1
fi

response=$(curl -w %{http_code} -o /dev/null -sH "Authorization: token ${GITHUB_OAUTH}" https://api.github.com/orgs/${GITHUB_ORG}/repos)
if [ ${response} -eq 401 ]; then
  error "unauthorized: invalid auth token for organization"
  exit 1
elif [ ${response} -ne 200 ]; then
  warn "unexpected: testing organization/repo access returned HTTP Response: ${response}"
  exit 1
fi

# 1 .. 10: limit's results to 500 repositories
while [[ ${remaining} -gt 0 && ${remaining} -lt 11  ]]
do
    clone_count=0
    cloner 50 ${remaining}
    if [ ${clone_count} -eq 50 ]; then
    	remaining+=1
    else
    	remaining=0
    fi

    total+=${clone_count}
done

inf "cloned repositories: ${total}"