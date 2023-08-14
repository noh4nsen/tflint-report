#!/bin/bash 

set -euo pipefail

projects=$(echo $1 | tr -d "'")

echo $projects | jq -r '.projects[]' | while read -r project; do
    cd $GITHUB_WORKSPACE/$project;
    report=$(jq -n -c --argjson $project "$(tflint)" '$ARGS.named')
    echo $report
done