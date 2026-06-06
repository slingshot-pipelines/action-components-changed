#!/bin/bash -eu

CHANGED_COMPONENTS=$(echo "$COMPONENTS_INFO" \
    | jq -rc --argjson changes "$CHANGES" \
    'to_entries | map(select(.key as $key | ($changes | any(. == $key)))) | from_entries')

CHANGES_BY_TYPE=$(echo "$CHANGED_COMPONENTS" \
    | jq -rc \
        'map(.) |
        group_by(.type) |
        map({ key: .[0].type, value: (. | map(.component)) }) |
        from_entries')

printf '%s' "$CHANGES_BY_TYPE"
