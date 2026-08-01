#!/bin/bash

set -euo pipefail

APP_NAME="kk-api"

APP_VERSION="${APP_VERSION:?APP_VERSION environment variable not set}"
DEPLOY_ENV="${DEPLOY_ENV:?DEPLOY_ENV environment variable not set}"
ARTIFACT_BASE_URL="${ARTIFACT_BASE_URL:?ARTIFACT_BASE_URL environment variable not set}"

APP_ROOT="/opt/kijanikiosk"
RELEASES_DIR="${APP_ROOT}/releases"

CHANGED=false

log() {
    echo "$1"
}

log_fail() {
    echo "$1"
}

fetch_artifact() {

    log "=== Phase 1: Fetch artifact ==="

    local artifact="${RELEASES_DIR}/${APP_NAME}-${APP_VERSION}.tar.gz"
    local url="${ARTIFACT_BASE_URL}/${APP_NAME}-${APP_VERSION}.tar.gz"

    mkdir -p "${RELEASES_DIR}"

    if [[ -f "${artifact}" ]]; then
        log "Artifact already downloaded: ${artifact}"
        return 0
    fi

    if ! curl -fsSL --max-time 60 "${url}" -o "${artifact}"; then
        log_fail "Phase 1 FAILED"
        exit 1
    fi

    log "Fetched: ${artifact}"
}

validate_artifact() {

    log "=== Phase 2: Validate artifact ==="

    local artifact="${RELEASES_DIR}/${APP_NAME}-${APP_VERSION}.tar.gz"

    if [[ ! -f "${artifact}" ]]; then
        log_fail "Phase 2 FAILED"
        exit 1
    fi

    tar -tzf "${artifact}" >/dev/null

    log "Artifact validation successful."
}

deploy_release() {

    log "=== Phase 3: Deploy ==="

    local artifact="${RELEASES_DIR}/${APP_NAME}-${APP_VERSION}.tar.gz"
    local target="/opt/kijanikiosk/${DEPLOY_ENV}"
    local version_file="${target}/.version"

    if [[ -f "${version_file}" ]]; then
        current=$(cat "${version_file}")

        if [[ "${current}" == "${APP_VERSION}" ]]; then
            log "Version ${APP_VERSION} already deployed to ${DEPLOY_ENV}. Skipping copy."
            return 0
        fi
    fi

    mkdir -p "${target}/app"

    rm -rf "${target}/app/"*

    tar -xzf "${artifact}" -C "${target}/app"

    chown -R kk-api:kijanikiosk "${target}/app"

    echo "${APP_VERSION}" > "${version_file}"

    CHANGED=true

    log "Deployment complete."
}

restart_service() {

    log "=== Phase 4: Restart Service ==="

    if [[ "${CHANGED}" == "false" ]]; then
        log "Skipping restart. Version unchanged."
        return 0
    fi

    if ! systemctl restart "${APP_NAME}-${DEPLOY_ENV}.service"; then
        log_fail "Phase 4 FAILED"
        exit 1
    fi

    log "Service restarted."
}

verify_deployment() {

    log "=== Phase 5: Verify ==="

    local port

    if [[ "${DEPLOY_ENV}" == "blue" ]]; then
        port=3000
    else
        port=3001
    fi

    if ! curl -fs "http://127.0.0.1:${port}/health"; then
        log_fail "Phase 5 FAILED"

        journalctl -u "${APP_NAME}-${DEPLOY_ENV}.service" -n 20 --no-pager

        exit 1
    fi

    echo
    log "Deployment verification successful."
}

main() {

    fetch_artifact

    validate_artifact

    deploy_release

    restart_service

    verify_deployment
}

main
