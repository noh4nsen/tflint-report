#!/bin/bash 

set -euo pipefail

projects=$1

echo $projects

echo $projects | jq -r '.projects[]' | while read -r repo; do
    echo $repo;
done