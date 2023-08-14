#!/bin/bash 

set -euo pipefail

projects=$1
report="[]"

while read -r project; do
    echo "--- Running TFLint on $project ---"

    cd $GITHUB_WORKSPACE/$project
    json_object=$(jq -n -c --argjson $project "$(tflint --format=json)" '$ARGS.named')
    echo $json_object | jq --arg project $project '.[$project].issues[].rule.name'
    report=$(jq --argjson obj "$json_object" '. + [$obj]' <<< "$report")

    echo -e "--- Finished Report on $project ---\n"
done < <(echo $projects | tr -d "'" | jq -r '.projects[]' )

echo "tflint_report='$(echo $report)'" >> $GITHUB_OUTPUT