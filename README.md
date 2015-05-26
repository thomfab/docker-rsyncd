rsync
=====

Simple rsync server running in a docker container

This is inspired by https://github.com/nabeken/docker-volume-container-rsync and https://github.com/bfosberry/rsync

## Basic usage

Launch the container via docker:
```
docker run -d -p <port>:873 --name rsyncd thomfab/rsyncd
```

You can connect to the rsync server you just created with:

```
rsync rsync://<docker>:<port>/
volume          volume
```

To sync:

```
rsync -avP /path/to/dir rsync://<docker>:<port>/volume/
```

## Advanced

Some variables can be customized :

### VOLUME
To set the name of the sync volume. Default is "volume"

Example :
```
docker run -d -p <port>:873 --name rsyncd \
              -e VOLUME="backup" \
              thomfab/rsyncd
```
which will give :
```
rsync rsync://<docker>:<port>/
backup          backup
```

### ALLOW
By default, rsync server accepts a connection only from `192.168.0.0/16` and `172.12.0.0/12` for security reasons.
You can override via an environment variable like this:

```
docker run -d -p <port>:873 \
              --name rsyncd \
              -e ALLOW='10.0.0.0/8 x.x.x.x/y' \
              thomfab/rsyncd
```

### OWNER
By default the user "nobody" is used. You can customize and pass the id of a user the docker host (so that file perms are correct).
Example, if your docker host has a user "ubuntu" with id 1000 you can use :
```
docker run -d -p <port>:873 \
           --name rsyncd \
           -e OWNER=1000 \
           thomfab/rsyncd
```
Files created in the volume by rsyncd will belong to the user ubuntu (see volumes below).

### GROUP
By default the group "nogroup" is used. You can also customize and pass the id of a group on the docker host.
Example, if your docker host has a group "users" with id 100 you can use :
```
docker run -d -p <port>:873 \
           --name rsyncd \
           -e GROUP=100 \
           thomfab/rsyncd
```
Files created in the volume by rsyncd will belong to the group users.

### Sync volume
The sync folder exposed by rsyncd is a docker volume. You can map it to a local folder on the docker host :
Example, if your docker host has a user "ubuntu" with id 1000 you can use :
```
docker run -d -p <port>:873 \
              --name rsyncd \
              -v /path/to/host/folder:/volume \
              thomfab/rsyncd
```

### Full example
```
docker run -d -p 873:873 \
              --name rsyncd \
              -e VOLUME="backup" \
              -e OWNER=1000 \
              -e GROUP=100 \
              -v /srv/backup:/volume \
              thomfab/rsyncd
```
This will start an rsync daemon, exposed on the standard port, with a volume named "backup", and map it to the host folder /srv/backup. Files created during sync will belong to user "ubuntu" and group "users" on a standard Ubuntu install.
