#!/usr/bin/env bash

set -euo pipefail

export SCRIPT_DIR="$(cd "$(dirname "$0")" ; pwd -P)"
LAST_COMMIT_SHA_FILE_NAME=".last_commit_sha"

_find_changed_files() {
  if test -f "$LAST_COMMIT_SHA_FILE_NAME"; then
    local last_commit_sha
    last_commit_sha=$(head -n 1 $LAST_COMMIT_SHA_FILE_NAME)
    git diff "${GITHUB_SHA}" "${last_commit_sha}" --name-only
  else
    git show --pretty="" --name-only "${GITHUB_SHA}"
  fi
}

_build_matrix_config() {
  local module_names=(module1 module2)
  local changed_modules=()
  local changed_files
  changed_files=$(_find_changed_files)

  for module_name in "${module_names[@]}"; do
    if grep -q "${module_name}/" <<<"${changed_files}"; then
      changed_modules+=("${module_name}")
    fi
  done

  if [ ${#changed_modules[@]} -eq 0 ]; then
    printf '%s\n' "${module_names[@]}" | jq -R '{"name":.}' | jq -s '{"include": .}'
  else
    printf '%s\n' "${changed_modules[@]}" | jq -R '{"name":.}' | jq -s '{"include": .}'
  fi
}

_update_last_commit_sha() {
  echo "${GITHUB_SHA}" > $LAST_COMMIT_SHA_FILE_NAME
}
