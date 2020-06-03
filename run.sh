#!/bin/bash
VOLUME=${VOLUME:-"volume"}
ALLOW=${ALLOW:-192.168.0.0/16 172.16.0.0/12}
OWNER=${OWNER:-65534}
GROUP=${GROUP:-65534}

# create users matching ids passed if necessary
if [[ ${GROUP} -ne 65534 && ${GROUP} -ge 1000 ]]; then
  if getent group ${GROUP} ; then groupdel ${GROUP}; fi
  groupadd -g ${GROUP} rsyncdgroup
fi

if [[ ${OWNER} -ne 65534 && ${OWNER} -ge 1000 ]]; then
  if getent passwd ${OWNER} ; then userdel -f ${OWNER}; fi
  useradd -l -u ${OWNER} -g ${GROUP} rsyncduser
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
