#!/bin/bash 

set -euo pipefail

echo $1 | jq -r '.projects[]' | while read -r repo; do
    echo $repo;
done