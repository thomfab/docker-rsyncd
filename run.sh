#!/bin/bash
VOLUME=${VOLUME:-"volume"}
ALLOW=${ALLOW:-192.168.0.0/16 172.16.0.0/12}
OWNER=${OWNER:-nobody}
GROUP=${GROUP:-nogroup}

# create users matching ids passed if necessary
if [ "${GROUP}" != "nogroup" ]; then
        groupadd -g ${GROUP} rsyncdgroup
fi
if [ "${OWNER}" != "nobody" ]; then
        groupadd -u ${OWNER} -G rsyncdgroup rsyncduser
fi

[ -f /etc/rsyncd.conf ] || cat <<EOF > /etc/rsyncd.conf
uid = ${OWNER}
gid = ${GROUP}
use chroot = yes
pid file = /var/run/rsyncd.pid
log file = /dev/stdout
[${VOLUME}]
    hosts deny = *
    hosts allow = ${ALLOW}
    read only = false
    path = /volume
    comment = ${VOLUME}
EOF

exec /usr/bin/rsync --no-detach --daemon --config /etc/rsyncd.conf "$@"
