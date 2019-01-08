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



#if [ "$TRAVIS_BRANCH" = "$TRAVIS_TAG" ]; then 
    echo "We are a release build!"
    env
#else
 #   echo Not Deploying!
  #  exit 0
#fi

if [ "$BASE_IMAGE" = "ubuntu" ] && [ "$DOCKER_DOWNGRADE" = "NO" ]; then
    echo "We are the correct job!"
else
    echo Not Deploying!
    exit 0
fi

if [ "$TRAVIS_REPO_SLUG" = "mq-cloudpak/testworkflow" ]; then
    echo "We are the correct repo!"
else
    echo Not Deploying!
    exit 0
fi

echo deployyyingggg!