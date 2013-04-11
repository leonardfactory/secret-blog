# Generate files and push to github
git checkout master
git add -A
git commit
git push origin master

jekyll
git checkout gh-pages
git rm -qr .
cp -r _site/. .
rm -r _site
git add -A
git commit
git push origin gh-pages
git checkout master
echo 'Published! You are a nice guy :)'