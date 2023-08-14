#!/bin/bash 

set -euo pipefail

projects=$(echo $1 | tr -d "'")

echo $projects | jq -r '.projects[]' | while read -r project; do
    echo $GITHUB_WORKSPACE/$project;
    ls -la;
done