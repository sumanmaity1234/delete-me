#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" ; pwd -P)"

. "${SCRIPT_DIR}/lib.sh"

function _usage() {
    cat <<EOF
Usage: $0 command
commands:
  build-matrix-config                       Build github action matrix json depends on changed files
  update-last-commit-sha                    Update commit sha in file
  
EOF
  exit 1
}

CMD=${1:-}
shift || true
case ${CMD} in
  build-matrix-config) _build_matrix_config ;;
  update-last-commit-sha) _update_last_commit_sha ;;
  *) _usage ;;
esac
