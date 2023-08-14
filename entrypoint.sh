#!/bin/bash 

set -euo pipefail

projects=$(echo $1 | tr -d "'")

echo $projects | jq -r '.projects[]' | while read -r repo; do
    echo $repo;
done