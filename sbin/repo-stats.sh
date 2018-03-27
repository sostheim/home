#!/bin/bash -
# title       : repo-stats.sh
# description : Given a repo, gather statistics about it.
# api         : https://developer.github.com/v3/repos/collaborators/
#               https://developer.github.com/v3/repos/statistics/
#               https://developer.github.com/v3/repos/releases/
#==============================================================================
set -o errexit
set -o nounset
set -o pipefail
# set -x

RAW_OUTPUT=false

sbin_dir=$(dirname "${BASH_SOURCE}")
source ${sbin_dir}/utils.sh 

function show_help {
  inf "Usage:"
  inf "  repo-stats.sh [flags]\n"
  inf "Flags:"
  inf "  -h|--help   - display this message"
  inf "  -r|--repo   - Required: GitHub repository name"
  inf "  -o|--org    - Required: GitHub organization/owner name"
  inf "  -t|--token  - Required: GitHub users OAuth token"
  inf "  -x          - Output data in row format"
  inf "Example:"
  inf "  $ repo-stats.sh --repo lbex --org sostheim --token e72e16c7e42f292c6912e7710c838347ae178b4a"
}

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
  -r|--repo)
  GITHUB_REPO="$2"
  shift
  ;;
  -o|--org)
  GITHUB_ORG="$2"
  shift
  ;;
  -t|--token)
  GITHUB_OAUTH="$2"
  shift
  ;;
  -x)
  RAW_OUTPUT=true
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

if [ -z "${GITHUB_REPO+x}" ]; then
  show_help
  exit 1
fi

if [ -z "${GITHUB_ORG+x}" ]; then
  show_help
  exit 1
fi

if [ -z "${GITHUB_OAUTH+x}" ]; then
  show_help
  exit 1
fi

find_or_die "jq"

url="https://api.github.com/repos/${GITHUB_ORG}/${GITHUB_REPO}"
response=$(curl -w %{http_code} -o /dev/null -sH "Authorization: token ${GITHUB_OAUTH}" ${url})
if [ ${response} -eq 401 ]; then
  error "unauthorized: invalid auth token for organization"
  exit 1
elif [ ${response} -ne 200 ]; then
  warn "unexpected: testing organization/repo access returned HTTP Response: ${response}"
  exit 1
fi

declare -i forks_count=0
declare -i stars_count=0
declare -i watches_count=0
declare -i contrib_count=0
declare -i issues_count=0
declare -i open_issues_count=0
declare -i closed_issues_count=0
declare -i pr_count=0
declare -i open_pr_count=0
declare -i merged_pr_count=0
declare -i closed_pr_count=0
declare -i commits_30_count=0
declare -i commits_90_count=0

# $1 -> url
declare -i paged_count=0
function paged_resource_counter {
    # not all github api v3 endpoints honor a `page_size` query parameter for pagination
    # so use the default (30) instead of trying to figure out which ones do/don't
    count=$(curl -sH "Authorization: token ${GITHUB_OAUTH}" ${1} | jq '. | length')
    if [ ${count} == 30 ]; then
        # GET HTTP returned headers only, grep out the "Link:" header 
        links=$(curl -I -sH "Authorization: token ${GITHUB_OAUTH}" ${1} | grep "Link:")
        last_link_start=`expr "${links}" : '.*, <'`
        last_link=${links:${last_link_start}}
        last_link_len=`expr "${last_link}" : '.*>; '`
        last_link_end=$((${last_link_len}-3)) # -3 (the len of chars needed to stop the regex)
        last_link=${last_link:0:${last_link_end}} 
        last_page_start=`expr "${last_link}" : '.*page='`
        last_page_num=${last_link:${last_page_start}}
        last_page_item_count=$(curl -sH "Authorization: token ${GITHUB_OAUTH}" ${last_link} | jq '. | length')
        paged_count=$((30 * $((${last_page_num}-1)) + ${last_page_item_count}))
    else
        paged_count=${count}
    fi
    # set +x
}

resp_body=$(curl -sH "Authorization: token ${GITHUB_OAUTH}" ${url})
FULL_NAME=$(jq .full_name <<< ${resp_body})
LICENSE=$(jq .license.name <<< ${resp_body})
FORKED=false
if [ "$(jq .fork <<< ${resp_body})" = true ] ; then
    FORKED=true
    forks_count=$(jq .source.forks_count <<< ${resp_body})
    stars_count=$(jq .source.stargazers_count <<< ${resp_body})
else
    forks_count=$(jq .forks_count <<< ${resp_body})
    stars_count=$(jq .stargazers_count <<< ${resp_body})
    watches_count=$(jq .subscribers_count <<< ${resp_body}) 
fi

paged_resource_counter "${url}/contributors"
contrib_count=${paged_count}

if [ ${FORKED} == false ] ; then
    paged_resource_counter "${url}/issues?state=all"
    issues_count=${paged_count}

    paged_resource_counter "${url}/issues"
    open_issues_count=${paged_count}

    paged_resource_counter "${url}/issues?state=closed"
    closed_issues_count=${paged_count}

    paged_resource_counter "${url}/pulls?state=all"
    pr_count=${paged_count}

    paged_resource_counter "${url}/issues"
    open_pr_count=${paged_count}

    paged_resource_counter "${url}/pulls?state=closed"
    closed_pr_count=${paged_count}
  
    # Unfortunately there is no such thing as `state=merged` Have to query for all pulls with a merge timestamp/commit sha.
    # paged_resource_counter "${url}/pulls?state=merged"
    # merged_pr_count=${paged_count}

    thirty_days_ago=$(date -jv -30d "+%Y-%m-%d")
    thirty_days_ago="${thirty_days_ago}T00:00:00Z"
    commits_resp=$(curl -sH "Authorization: token ${GITHUB_OAUTH}" ${url}/commits?since=${thirty_days_ago})
    LAST_COMMIT=$(jq '.[0].commit.committer.date' <<< ${commits_resp})
    paged_resource_counter "${url}/commits?since=${thirty_days_ago}"
    commits_30_count=${paged_count}
    ninety_days_ago=$(date -jv -90d "+%Y-%m-%d")
    ninety_days_ago="${ninety_days_ago}T00:00:00Z"
    paged_resource_counter "${url}/commits?since=${ninety_days_ago}\&until=${thirty_days_ago}"
    commits_90_count=$(( ${paged_count} + ${commits_30_count} ))
else
    if [ ${RAW_OUTPUT} == true ] ; then
        error "unable to generate raw output for forked repositories."
        exit 1
    fi
fi

echo "Github Repository: ${FULL_NAME} (fork: ${FORKED}) - Information and Statistics"
if [ ${RAW_OUTPUT} == true ] ; then
    echo "repo stats: watches, stars, forks, contributors, issues(open, closed, total), pulls(open, closed, total), all issues + pulls(open, closed, total)"
    echo "${watches_count}, ${stars_count}, ${forks_count}, ${contrib_count}, $((${open_issues_count}-${open_pr_count})), $((${closed_issues_count}-${closed_pr_count})), $((${issues_count}-${pr_count})), ${open_pr_count}, ${closed_pr_count}, ${pr_count}, ${open_issues_count}, ${closed_issues_count}, ${issues_count}"
    exit 0
fi

if [ ${FORKED} == true ] ; then
    echo "        source repositories community statistics: $(jq .parent.full_name <<< ${resp_body})"
else
    echo "        license - ${LICENSE}"
    echo "        community statistics"
    echo "                watches: ${watches_count}"
fi
echo "                stars: ${stars_count}"
echo "                forks: ${forks_count}"
echo "                contributors: ${contrib_count}"
echo "                last commit date: ${LAST_COMMIT}"
echo "                commits last 30 days: ${commits_30_count}"
echo "                commits last 90 days: ${commits_90_count}"

if [ ${FORKED} == true ] ; then
    echo "All other statistics only reported for source repositories - not forks"
    exit 0
fi 

echo "        issues statistics"
echo "                open: $((${open_issues_count}-${open_pr_count}))"
echo "                closed: $((${closed_issues_count}-${closed_pr_count}))"
echo "                total: $((${issues_count}-${pr_count}))"
echo "        pull request statistics"
echo "                open: ${open_pr_count}"
echo "                closed: ${closed_pr_count}"
# echo "                merged: ${merged_pr_count}"
echo "                total: ${pr_count}"
echo "        total issues (issues + pull request) statistics"
echo "                open: ${open_issues_count}"
echo "                closed: ${closed_issues_count}"
echo "                total: ${issues_count}"
