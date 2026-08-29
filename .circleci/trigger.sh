#!/bin/bash

# Run using: bash trigger.sh

# Visit CircleCI Plan: https://app.circleci.com/settings/plan/circleci/3TbHDD9h6ossUWcgQSMt5g/overview
# https://app.circleci.com/insights/circleci/3TbHDD9h6ossUWcgQSMt5g/2U8vy5Ej4AoKZeNJTMFGiz


export USERNAME="soufiane-org"
# TODO: Create token: https://app.circleci.com/settings/user/tokens
export REPO="flutterci"
export CIRCLE_TOKEN=""
export BRANCH="main"
export FLUTTER_VERSION="3.47.2"
export XCODE_VERSION="26.4.0"


curl -X POST "https://circleci.com/api/v2/project/gh/${USERNAME}/${REPO}/pipeline" \
    -H "Content-Type: application/json" \
    -H "Circle-Token: ${CIRCLE_TOKEN}" \
    -d '{
        "branch": "'"${BRANCH}"'",
        "parameters": {
            "flutter_version": "'"${FLUTTER_VERSION}"'",
            "xcode_version": "'"${XCODE_VERSION}"'"
        }
    }'