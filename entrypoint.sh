#!/bin/bash 

set -euo pipefail

projects=$(echo $1 | tr -d "'")
report="[]"
echo "$projects"
echo "TESTE"

echo $projects | jq -r '.projects[]' | while read -r project; do
    cd $GITHUB_WORKSPACE/$project;

    echo "$project";
    json_object=$(jq -n -c --argjson $project "$(tflint --format=json)" '$ARGS.named');
    echo "$json_object";
    report=$(jq --argjson obj "$json_object" '. + [$obj]' <<< "$report");
    echo "$report";
done

echo "$report"