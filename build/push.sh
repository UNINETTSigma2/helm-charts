#!/bin/bash
set -e
# Copied from: https://gist.github.com/willprice/e07efd73fb7f13f917ea

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "GA - CI"
}

commit_files() {
  git checkout master
  git add docs/
  git add repos/*/*/package_versions.json
  git commit --message "GA build: $GITHUB_RUN_ID"
}

upload_files() {
  git remote set-url origin https://${GH_TOKEN}@github.com/Uninett/helm-charts.git > /dev/null 2>&1
  git push --set-upstream origin master
}

changes() {
  git diff --name-only --diff-filter=ADMR @~..@
}

#if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
#   exit 0;
#fi
#if [ "$TRAVIS_BRANCH" != "master" ]; then
#   exit 0;
#fi

setup_git
commit_files

echo "changes are:"
changes
echo "-------------"

# Only push changes if more than the index changed this build.
if changes | grep -vE 'index.yaml|.*.sh|.travis|.github|README|LICENSE|build'; then
  upload_files
fi
