# Fat Sentry

Don't you hate running 30 containers just for Sentry? We do. We really do!
Introducing Fat Sentry or as you may like to call it "The Holy Sentry Stack".
Thanks to the glorious DIND (Docker-in-Docker) technology, Sentry can now be run in a single container.

Don't you want to replace that:
```
CONTAINER ID   IMAGE                                    COMMAND                  CREATED          STATUS                    PORTS                          NAMES
21cd5b7d1d48   nginx:1.21.6-alpine                      "/docker-entrypoint.…"   10 minutes ago   Up 8 minutes              0.0.0.0:9000->80/tcp           sentry-self-hosted-nginx-1
6b137dd26b23   getsentry/relay:22.2.0                   "/bin/bash /docker-e…"   10 minutes ago   Up 8 minutes              3000/tcp                       sentry-self-hosted-relay-1
1bf0e18da9ca   getsentry/sentry:22.2.0                  "/etc/sentry/entrypo…"   10 minutes ago   Up 9 minutes              9000/tcp                       sentry-self-hosted-cron-1
789b63721492   getsentry/sentry:22.2.0                  "/etc/sentry/entrypo…"   10 minutes ago   Up 9 minutes              9000/tcp                       sentry-self-hosted-subscription-consumer-transactions-1
d06c9c0396ed   symbolicator-cleanup-self-hosted-local   "/entrypoint.sh '55 …"   10 minutes ago   Up 10 minutes             3021/tcp                       sentry-self-hosted-symbolicator-cleanup-1
7ccd558bc2cc   getsentry/sentry:22.2.0                  "/etc/sentry/entrypo…"   10 minutes ago   Up 9 minutes              9000/tcp                       sentry-self-hosted-worker-1
23d266f3ea7d   snuba-cleanup-self-hosted-local          "/entrypoint.sh '*/5…"   10 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-transactions-cleanup-1
887228ea5a0c   getsentry/sentry:22.2.0                  "/etc/sentry/entrypo…"   10 minutes ago   Up 9 minutes              9000/tcp                       sentry-self-hosted-subscription-consumer-events-1
f749935ab237   getsentry/sentry:22.2.0                  "/etc/sentry/entrypo…"   10 minutes ago   Up 9 minutes (healthy)    9000/tcp                       sentry-self-hosted-web-1
fc7e72d40d82   getsentry/sentry:22.2.0                  "/etc/sentry/entrypo…"   10 minutes ago   Up 9 minutes              9000/tcp                       sentry-self-hosted-post-process-forwarder-1
bde01c288c74   snuba-cleanup-self-hosted-local          "/entrypoint.sh '*/5…"   10 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-cleanup-1
7dfda84bfcd1   getsentry/sentry:22.2.0                  "/etc/sentry/entrypo…"   10 minutes ago   Up 9 minutes              9000/tcp                       sentry-self-hosted-ingest-consumer-1
005e1e3863f6   sentry-cleanup-self-hosted-local         "/entrypoint.sh '0 0…"   10 minutes ago   Up 9 minutes              9000/tcp                       sentry-self-hosted-sentry-cleanup-1
924d33aa7927   getsentry/snuba:22.2.0                   "./docker_entrypoint…"   13 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-sessions-consumer-1
eea148fdecc1   postgres:9.6                             "/opt/sentry/postgre…"   13 minutes ago   Up 10 minutes (healthy)   5432/tcp                       sentry-self-hosted-postgres-1
68b7ccc0522a   getsentry/snuba:22.2.0                   "./docker_entrypoint…"   13 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-subscription-consumer-events-1
b959378abb79   getsentry/snuba:22.2.0                   "./docker_entrypoint…"   13 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-transactions-consumer-1
4073b43c0705   tianon/exim4                             "docker-entrypoint.s…"   13 minutes ago   Up 10 minutes             25/tcp                         sentry-self-hosted-smtp-1
0c0d24c6ce9d   getsentry/symbolicator:0.4.2             "/bin/bash /docker-e…"   13 minutes ago   Up 10 minutes             3021/tcp                       sentry-self-hosted-symbolicator-1
c6210d217f18   getsentry/snuba:22.2.0                   "./docker_entrypoint…"   13 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-outcomes-consumer-1
2d6e0e649e13   getsentry/snuba:22.2.0                   "./docker_entrypoint…"   13 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-consumer-1
129494f97ca7   getsentry/snuba:22.2.0                   "./docker_entrypoint…"   13 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-subscription-consumer-transactions-1
4828a4faa366   getsentry/snuba:22.2.0                   "./docker_entrypoint…"   13 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-replacer-1
de7b8e4c8993   getsentry/snuba:22.2.0                   "./docker_entrypoint…"   13 minutes ago   Up 9 minutes              1218/tcp                       sentry-self-hosted-snuba-api-1
b3a6f914067f   memcached:1.6.9-alpine                   "docker-entrypoint.s…"   13 minutes ago   Up 10 minutes (healthy)   11211/tcp                      sentry-self-hosted-memcached-1
85161eb7dd4e   confluentinc/cp-kafka:5.5.0              "/etc/confluent/dock…"   15 minutes ago   Up 9 minutes (healthy)    9092/tcp                       sentry-self-hosted-kafka-1
84aacf46eafc   yandex/clickhouse-server:20.3.9.70       "/entrypoint.sh"         15 minutes ago   Up 10 minutes (healthy)   8123/tcp, 9000/tcp, 9009/tcp   sentry-self-hosted-clickhouse-1
00b36fdf664f   confluentinc/cp-zookeeper:5.5.0          "/etc/confluent/dock…"   15 minutes ago   Up 10 minutes (healthy)   2181/tcp, 2888/tcp, 3888/tcp   sentry-self-hosted-zookeeper-1
0d632bb2265b   redis:6.2.4-alpine                       "docker-entrypoint.s…"   15 minutes ago   Up 10 minutes (healthy)   6379/tcp                       sentry-self-hosted-redis-1
```

With this pretty, single entry?:
```
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS          PORTS                                                 NAMES
b7f6dd1661e1   okaeri/fat-sentry:22.2.0   "/usr/local/bin/entr…"   17 minutes ago   Up 17 minutes   2375/tcp, 0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   sentry
```

## Run it!

Expect about 10 minutes for clean startup and about a minute for the latter ones.

```console
# create volumes
docker volume create sentry-dind
docker volume create sentry-lib
# create container
docker run --privileged \
 -p 9000:9000 \
 --mount source=sentry-dind,target=/var/lib/docker \
 --mount source=sentry-lib,target=/sentry \
 -d --name sentry okaeri/fat-sentry:22.2.0-3
```

## Environment variables

Remember: Only applicable for the first (install) startup!

```dockerfile
ENV SENTRY_ADMIN_EMAIL=admin@example.com
ENV SENTRY_ADMIN_PASSWORD=admin
```

## Persistent storage

Current persistent storage is a bit of crude as it requires storing the whole docker layer (binding volume on `/var/lib/docker`).
Main reason for this is we don't have to track changes sentry makes in theirs volumes, also container recreation does 
not require lengthy installation process each time.

## Updating

What? Do you really expect it to be that easy? It actually probably is, at least in theory:
1) Backup your installation (best chances with quick backup).
2) Test restore on current installation to check if everything is working.
3) Remove fat-sentry container and volumes.
4) Create fat-sentry container with new version of the image.
5) Restore backup on the new version.

## Backups

Adapted to DIND from [Sentry help page on Self-Hosted Backup & Restore](https://develop.sentry.dev/self-hosted/backup/).

### Quick Backup

> If you need a quick way to backup and restore your Sentry instance and you don't need historical event data, 
> you can use the built in export and import commands. These commands will save and load all project and user 
> data, but will not contain any event data.

#### Backup
```console
docker exec -it sentry /bin/bash -c 'docker-compose run --rm -T -e SENTRY_LOG_LEVEL=CRITICAL web export > /sentry/sentry/backup.json'
docker exec -it sentry cat /sentry/sentry/backup.json > backup.json
```

You may need to remove non-json artifacts from the `backup.json` file, see e.g. [sentry#30396](https://github.com/getsentry/sentry/issues/30396).

#### Restore

```console
docker cp backup.json sentry:/sentry/sentry/backup.json
docker exec -it sentry /bin/bash -c 'docker-compose run --rm -T web import /etc/sentry/backup.json'
```

Failing with `django.core.serializers.base.DeserializationError`? Check your `backup.json` for non-json elements like `Updating certificates in /etc/ssl/certs...` and other log lines.

### Full Backup

You will surely figure it out! Let us know if you do!
