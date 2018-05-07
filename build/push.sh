#!/bin/bash
set -e
# Copied from: https://gist.github.com/willprice/e07efd73fb7f13f917ea

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

commit_website_files() {
  git checkout master
  git add docs/
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git remote set-url origin https://${GH_TOKEN}@github.com/UNINETT/helm-charts.git > /dev/null 2>&1
  git push --set-upstream origin master
}

changes() {
  git diff --name-only --diff-filter=ADMR @~..@
}

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
   exit 0;
fi
if [ "$TRAVIS_BRANCH" != "master" ]; then
   exit 0;
fi

setup_git
commit_website_files

# Only push changes if more than the index changed this build.
if changes | grep -vE 'index.yaml|.*.sh|.travis|README|LICENSE|build'; then
  upload_files
fi
