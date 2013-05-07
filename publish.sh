#!/bin/bash -e
# Generate files and push to github
git checkout master
rm -rf _template/css/.sass-cache/
git add -A
git status -s | git commit -F- # Use last edits short description to make commit message
git push origin master || exit

jekyll build || exit
git checkout gh-pages
git rm -qr .
cp -r _site/. .
rm -r _site
git add -A
git status -s | git commit -F-
git push origin gh-pages || exit
git checkout master
echo 'Published! You are a nice guy :)'
