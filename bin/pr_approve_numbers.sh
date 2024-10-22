#!/usr/bin/env bash
set -euo pipefail
# for debugging:
#set -o xtrace

ghapi() {
  # does retries

  gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" $@ || \
  (sleep 5 && gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" $@)
}

date_cutoff="2024-09-01"

getPrsForAuthor() {
  local -r repo="${1}"
  local -r author="${2}"
  raw_response="$(
    ghapi \
      --paginate \
      --slurp \
      "/search/issues?q=is:pr+repo:${repo}+author:${author}+created:>${date_cutoff}+is:merged"
    )"
  # Returns the raw numbers
  echo "$raw_response" | jq ' .[] | .items.[] | .number'
}

getReviews() {
  local -r repo="${1}"
  local -r number="${2}"
  ghapi \
    "/repos/${repo}/pulls/${number}/reviews"
}

repos=("datadog/dd-source" "datadog/dd-go" "datadog/dogweb" "datadog/web-ui" "datadog/logs-backend")
authors=("wittekm" "vbarth2" "danielhsu93" "kevin8cao" "nkonjeti" "T-Kuo" "2scott2furious" "jgrillo-ddog" "ddeep2007" )

# a map from author to number of PRs approved
declare -A total_approves

handleSinglePr() {
  local -r repo="${1}"
  local -r pr="${2}"

  reviews="$(getReviews "${repo}" "$pr")"

  # jq filter by where state = APPROVED
  approvers_string="$(
    echo "$reviews" | \
    jq --compact-output --raw-output '.[] | select(.state == "APPROVED") | .user.login')"

  if [[ -z "$approvers_string" ]]; then
    echo "No approvers found for PR number ${pr}"
    return
  fi

  #readarray from approvers_string
  approvers=()
  while IFS= read -r approver; do
    approvers+=("$approver")
  done <<< "$approvers_string"

  echo "For PR number ${pr}, approvers were: ${approvers[*]}"

  # iterate over approvers array
  for approver in "${approvers[@]}"; do
    # Update total_approves array
    if [[ -v total_approves[$approver] ]]; then
      total_approves[$approver]=$((total_approves["$approver"] + 1))
    else
      total_approves[$approver]=1
    fi
  done
}

for author in "${authors[@]}"; do
  echo -e "\n===== For PRs authored by ${author}, reviewers were: =====\n"
  for repo in "${repos[@]}"; do
    prs_string="$(getPrsForAuthor "${repo}" "${author}")"

    if [[ -z "$prs_string" ]]; then
      echo "No PRs found for author ${author} in repo ${repo}"
      continue
    fi
    # convert to bash array
    prs=()
    while IFS= read -r pr; do
      prs+=("$pr")
    done <<< "$prs_string"
    echo -e "--- for repo ${repo}, number of PRs since ${date_cutoff}: ${#prs[@]} ---"

    # for each pr
    for pr in "${prs[@]}"; do
      handleSinglePr "${repo}" "$pr"
    done
  done
done

echo -e "\n\n====== total approvals ======\n\n"
for approver in "${!total_approves[@]}"; do
  # if approver is in authors
  if [[ " ${authors[@]} " =~ " ${approver} " ]]; then
    printf "[%q]=%q\n" "$approver" "${total_approves[$approver]}"
  fi
done