function _openUrl() {
    for vhost in $(docker-compose config | _yq e '.services.*.environment.VIRTUAL_HOST');  do
         if [[ "${vhost}" != "null" ]]; then
            _logYellow "visit: https://${vhost}"
        fi
    done
}
