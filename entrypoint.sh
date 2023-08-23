#!/bin/bash 

set -euo pipefail

projects=$1
report="[]"

if [[ $projects == *null* ]]; then
    echo "--- No projects to run TFLint on ---"
    echo "tflint_report=$(echo $report)" >> $GITHUB_OUTPUT
    exit 0
fi

while read -r project; do
    echo "--- Running TFLint on $project ---"

    cd $GITHUB_WORKSPACE/$project
    report=$(jq --argjson obj "$(jq -n -c --arg "project" $project '$ARGS.named' --argjson "report" "$(tflint --format=json)" '$ARGS.named')" '. + [$obj]' <<< "$report")

    echo -e "--- Finished Report on $project ---\n"
done < <(echo $projects | tr -d "'" | jq -r '.projects[]' )


echo "tflint_report=$(echo -n $report | base64)" >> $GITHUB_OUTPUT