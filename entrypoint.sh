#!/bin/bash 

set -euo pipefail

projects=$1
report="[]"

if [[ $(echo $projects | tr -d "'" | jq -r '.projects[]') == "null" ]]; then
    echo "--- No projects to scan ---"
    echo "tflint_report='$(echo $report)'" >> $GITHUB_OUTPUT
    exit 0
fi

while read -r project; do
    echo "--- Running TFLint on $project ---"

    cd $GITHUB_WORKSPACE/$project
    report=$(jq --argjson obj "$(jq -n -c --argjson $project "$(tflint --format=json)" '$ARGS.named')" '. + [$obj]' <<< "$report")

    echo -e "--- Finished Report on $project ---\n"
done < <(echo $projects | tr -d "'" | jq -r '.projects[]' )

echo "tflint_report='$(echo $report)'" >> $GITHUB_OUTPUT