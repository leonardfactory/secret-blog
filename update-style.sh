#!/bin/bash -e
# Update styles
echo "Updating styles."
compass compile _template/css
cp _template/css/screen.css assets/css/screen.css
jekyll --no-auto
echo 'Updated! Beatiful code, man.'