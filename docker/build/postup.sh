#!/bin/bash
redirportdistant() {
    redir --lport=${1} --caddr=$WG_ROUTER_IP --cport=${1} &
}

rediripportlocal() {
    
    redir --lport=${1} --caddr=${2} --cport=${3} &
}

### Mapping Remote PORT to the local HOST
for p in ${DISTANT_OPEN_PORTS[@]}; do
    redirportdistant $p
done

for p in ${LOCAL_NETWORK_REDIRECTS[@]}; do
    IFS=':' read -r -a redirect <<< $p
    rediripportlocal ${redirect[0]} ${redirect[1]} ${redirect[2]}
done