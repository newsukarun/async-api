#!/bin/bash
set -ex

# Bundle the docs to html and copy to the docs/ folder
npm run build

# Copy all the yaml files to the docs/ folder
cp -r output/ docs/

# Ensure we have git appropriately configured to be able to commit & push
git config --global user.name "$( git log --format=%an -n 1 ${COMMIT_SHA} )"
git config --global user.email "$( git log --format=%ae -n 1 ${COMMIT_SHA} )"

# Deploy
if [ -z "$CIRCLE_TAG" ]; then
  # Deploy latest
  npx gh-pages-multi deploy --template index.pug;
else
  # Deploy specific tagged version
  npx gh-pages-multi deploy --template index.pug --better-target --target $CIRCLE_TAG;
fi
