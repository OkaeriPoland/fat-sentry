#!/bin/bash
set -e
export CI=1
create_user=false
cd /sentry

# install sentry sources
if [ ! -f /sentry/install.sh ]; then
  echo "==> Installing files..."
  cp --verbose -rf /sentrysrc/. /sentry/.
fi

# only install if no sentry containers
if [ ! "$(docker ps -all -q -f name=sentry-self-hosted-)" ]; then
  echo "==> Installing sentry..."
  ./install.sh --skip-user-prompt
  create_user=true
fi

# start sentry stack
echo "==> Waking up sentry..."
docker-compose up -d

# create user if fresh install
if [ "$create_user" = true ]; then
  echo "==> Creating superuser..."
   # apparently we can't have nice things so here it goes!
  sentry_web=$(docker ps -q -f name=sentry-self-hosted-web-)
  docker exec "$sentry_web" /bin/bash -c "yes | sentry createuser --superuser --email ""$SENTRY_INIT_ADMIN_EMAIL"" --password ""$SENTRY_INIT_ADMIN_PASSWORD"""
fi

# watch sentry for being alive
echo "==> Fat Sentry started!"
while [ "$(curl -s --request GET http://127.0.0.1:9000/_health/)" = "ok" ]; do
    sleep 1
done

# message before exiting
echo "==> Health check failed! Exiting..."
