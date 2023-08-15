#!/bin/bash 

set -euo pipefail

projects=$1
report="[]"
report_full=""

#check $projects contains null word in it without "" or '', if yes then exit the action without error
if [[ $projects == *null* ]]; then
    echo "--- No projects to run TFLint on ---"
    echo "tflint_report='$(echo $report)'" >> $GITHUB_OUTPUT
    exit 0
fi

while read -r project; do
    echo "--- Running TFLint on $project ---"

    cd $GITHUB_WORKSPACE/$project
    report=$(jq --argjson obj "$(jq -n -c --argjson $project "$(tflint --format=json)" '$ARGS.named')" '. + [$obj]' <<< "$report")
    report_full=$(echo "--- Project $project ---" && "$(tflint)" <<< "$report_full")

    echo -e "--- Finished Report on $project ---\n"
done < <(echo $projects | tr -d "'" | jq -r '.projects[]' )

echo $report_full

echo "tflint_report='$(echo $report)'" >> $GITHUB_OUTPUT