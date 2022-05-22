FROM okaeri/debian-dind:20.10.12-bullseye

RUN apt update
RUN apt install git -y

ARG SENTRY_VERSION=22.5.0
RUN mkdir /sentry
RUN git clone --branch "$SENTRY_VERSION" https://github.com/getsentry/self-hosted sentry

COPY entrypoint.sh /sentry/entrypoint.sh
RUN chmod +x /sentry/entrypoint.sh

VOLUME /sentry
WORKDIR /sentry

ENV SENTRY_INIT_ADMIN_EMAIL=admin@example.com
ENV SENTRY_INIT_ADMIN_PASSWORD=admin

EXPOSE 9000
CMD ["/sentry/entrypoint.sh"]
