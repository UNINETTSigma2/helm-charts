#!/bin/sh
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

setup_git
commit_website_files
upload_files
