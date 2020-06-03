rsync
=====

Simple rsync server running in a docker container

## Basic usage

Launch the container via docker:
```
docker run -d -p <port>:873 --name rsyncd thomfab/docker-rsyncd
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
              thomfab/docker-rsyncd
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
              thomfab/docker-rsyncd
```

### Sync volume
The sync folder exposed by rsyncd is a docker volume. You can map it to a local folder on the docker host :
```
docker run -d -p <port>:873 \
              --name rsyncd \
              -v /path/to/host/folder:/volume \
              thomfab/docker-rsyncd
```

### Full example
```
docker run -d -p 873:873 \
              --name rsyncd \
              --user 1000:100 \
              -e VOLUME="backup" \
              -v /srv/backup:/volume \
              thomfab/docker-rsyncd
```
This will start an rsync daemon, exposed on the standard port, with a volume named "backup", and map it to the host folder /srv/backup. Files created during sync will belong to user "ubuntu" and group "users" on a standard Ubuntu install.
