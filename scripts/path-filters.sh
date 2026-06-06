#!/bin/bash -eu

COMPONENT_NAMES=$(printf '%s' "$COMPONENTS_INFO" | jq -rc 'keys | .[]')

HAS_GITHUB=$(echo "$COMPONENT_NAMES" | jq -Rsrc 'split("\n") | any(. == ".github")')
if [[ "$HAS_GITHUB" == "true" ]]; then
    echo ".github:"
    echo "  - '.github/actions/**'"
    echo "  - '.github/workflows/**'"
fi

while IFS='' read -r COMPONENT && [[ -n "$COMPONENT" ]]; do
    COMPONENT_INFO=$(echo "$COMPONENTS_INFO" \
        | jq -rc --arg component "$COMPONENT" '.[$component]')

    COMPONENT_PATH=$(echo "$COMPONENT_INFO" | jq -rc '.path // ""')
    if [[ -n "$COMPONENT_PATH" ]]; then
        echo "$COMPONENT:"
        echo "  - '$COMPONENT_PATH/**'"
        continue
    fi

    COMPONENT_PATHS=$(echo "$COMPONENT_INFO" | jq -rc '.paths // []')
    if [[ "$COMPONENT_PATHS" != '[]' ]]; then
        echo "$COMPONENT:"
        echo "$COMPONENT_PATHS" | yq -o=yaml -P 'map("\(.)/**")'
    fi
done <<< "$COMPONENT_NAMES"
