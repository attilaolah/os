#!/usr/bin/env bash
set -euo pipefail

readonly FILE='overlays/qwen_code.nix'
readonly FAKE_HASH='sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
readonly LOG_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "${LOG_DIR}"
}
trap cleanup EXIT

set_hash_value() {
  local key="$1"
  local value="$2"
  sed -i -E "s|^([[:space:]]*${key}[[:space:]]*=[[:space:]]*\").*(\";)$|\\1${value}\\2|" "${FILE}"
}

extract_got_hash() {
  local log_file="$1"
  grep -Eo 'got:[[:space:]]*sha256-[A-Za-z0-9+/=]+' "${log_file}" \
    | sed -E 's/.*(sha256-[A-Za-z0-9+/=]+).*/\1/' \
    | tail -n1
}

build_qwen_code() {
  local log_file="$1"
  nix build \
    --no-link \
    --print-build-logs \
    .#qwen-code \
    2>&1 | tee "${log_file}"
}

# 1) Force src hash mismatch and capture the expected source hash.
set_hash_value "hash" "${FAKE_HASH}"
if build_qwen_code "${LOG_DIR}/src.log"; then
  echo 'Expected source hash mismatch, but build succeeded.' >&2
  exit 1
fi

src_hash="$(extract_got_hash "${LOG_DIR}/src.log")"
if [[ -z "${src_hash}" ]]; then
  echo 'Failed to extract source hash from build output.' >&2
  exit 1
fi
set_hash_value "hash" "${src_hash}"

# 2) Force npmDeps hash mismatch and capture expected npmDepsHash.
set_hash_value "npmDepsHash" "${FAKE_HASH}"
if build_qwen_code "${LOG_DIR}/npm.log"; then
  echo 'Expected npmDeps hash mismatch, but build succeeded.' >&2
  exit 1
fi

npm_deps_hash="$(extract_got_hash "${LOG_DIR}/npm.log")"
if [[ -z "${npm_deps_hash}" ]]; then
  echo 'Failed to extract npmDepsHash from build output.' >&2
  exit 1
fi
set_hash_value "npmDepsHash" "${npm_deps_hash}"

# 3) Verify final build succeeds with updated hashes.
build_qwen_code "${LOG_DIR}/verify.log"
