#!/bin/bash 

set -euo pipefail

projects=$(echo $1 | tr -d "'")
report="[]"

echo $projects | jq -r '.projects[]' | while read -r project; do
    cd $GITHUB_WORKSPACE/$project;
    json_object=$(jq -n -c --argjson $project "$(tflint --format=json)" '$ARGS.named')
    report=$(jq --argjson obj "$json_object" '. + [$obj]' <<< "$report")
done

echo $report | jq