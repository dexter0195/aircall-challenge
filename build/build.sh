#!/bin/bash

# Clone the source repo
REPO_URL="https://github.com/aircall/sre-hiring-test.git"

git clone $REPO_URL
git checkout $COMMIT_SHA src

# Install packages
cd src
npm install

# Package the release zip file
rm -rf .git
zip -r src.zip ./*
mv ./src.zip ../src.zip