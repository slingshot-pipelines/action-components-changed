#!/bin/bash -eu

printf '%s' "$COMPONENTS_INFO" \
    | jq -rc 'to_entries | map(.key) | sort'
