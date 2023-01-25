## Update dde system
#
# Command
#    system:update
#    system-update

function system:update() {
    _logRed "Removing dde (system)"
    system:destroy

    _logYellow "Updating dde repository"
    cd ${ROOT_DIR}
    git pull

    _logYellow "Updating docker images"
    cd ${ROOT_DIR}
    ${DOCKER_COMPOSE} pull
    docker pull mikefarah/yq
    ${DOCKER_COMPOSE} build --pull


    cd services/conf.d

    for f in *; do
        if [ -f ${ROOT_DIR}/services/${f}/docker-compose.yml ]; then
            _logYellow "Update service ${f}"
            cd ${ROOT_DIR}/services/${f}
            ${DOCKER_COMPOSE} pull
            ${DOCKER_COMPOSE} build --pull
        fi
    done

    cd ${ROOT_DIR}

    _ddeCheckNetwork

    system:services:enable dnsmasq
    system:services:enable mailhog
    system:services:enable mariadb
    system:services:enable reverseproxy

    _logYellow "Starting dde (system)"
    system:up

    _logGreen "Finished update successfully"
}

function system-update() {
    system:update
}
