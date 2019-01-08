#!/bin/bash

# © Copyright IBM Corporation 2019
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# test if release build


set -e

if [ "$TRAVIS_BRANCH" = "$TRAVIS_TAG" ]; then 
    echo "We are a release build!"
else
   echo Not Deploying!
   exit 0
fi

# test is one particular job

if [ "$BASE_IMAGE" = "ubuntu" ] && [ "$DOCKER_DOWNGRADE" = "NO" ]; then
    echo "We are the correct job!"
else
    echo Not Deploying!
    exit 0
fi

# test if we are GHE not GH

if [ "$TRAVIS_REPO_SLUG" = "mq-cloudpak/testworkflow" ]; then
    echo "We are the correct repo!"
else
    echo Not Deploying!
    exit 0
fi

echo Deploying to GitHub!

# Add GH as a remote and test we have no commits missing

echo "Checking for any missing commits"
git remote add GH https://${GH_TOKEN}@github.com/parrobe/testworkflow.git

git fetch GH

MERGELOG=`git merge GH/master`
echo $MERGELOG
if [[ "$MERGELOG" != *"Already up-to-date."* ]]; then
    echo "Error: we have commits waiting to be merged"
    echo "$MERGELOG"
    exit 1
fi

echo "pushing to changes to a new branch on github.com called 'release_$TRAVIS_TAG'"
# create GH directory structure
git config --global user.email "parrobe@uk.ibm.com"
git config --global user.name "parrobe"

cd ../../
mkdir -p github.com/parrobe
cd github.com/parrobe
git clone https://${GH_TOKEN}@github.com/parrobe/testworkflow.git
cd testworkflow
git remote add GHE https://${GHE_TOKEN}@github.ibm.com/mq-cloudpak/testworkflow.git
git fetch GHE
git checkout -b release_$TRAVIS_TAG $TRAVIS_TAG
git push origin release_$TRAVIS_TAG

git request-pull origin/master ./

curl -X POST -u parrobe:${GH_TOKEN} -k \
  -d '{"title": "New feature $TRAVIS_TAG","head": "release_$TRAVIS_TAG","base": "master"}' \
  https://api.github.com/repos/parrobe/testworkflow/pulls

echo "PR on github.com for release should be available now!"