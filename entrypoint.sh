#!/bin/bash 

set -euo pipefail

projects=$(echo $1 | tr -d "'")
report="[]"
echo $report

echo $projects | jq -r '.projects[]' | while read -r project; do
    cd $GITHUB_WORKSPACE/$project
    json_object=$(jq -n -c --argjson $project "$(tflint --format=json)" '$ARGS.named')
    report=$(jq --argjson obj "$json_object" '. + [$obj]' <<< "$report")
    echo $report | jq
done

echo $report

echo "tflint_report='$(echo $report)'" >> $GITHUB_OUTPUT