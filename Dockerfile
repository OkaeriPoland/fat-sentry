FROM okaeri/debian-dind:20.10.12-bullseye

RUN apt update && \
    apt install git -y

ARG SENTRY_VERSION=22.5.0
RUN mkdir /sentrysrc && \
    git clone --branch "$SENTRY_VERSION" https://github.com/getsentry/self-hosted sentrysrc

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV SENTRY_INIT_ADMIN_EMAIL=admin@example.com
ENV SENTRY_INIT_ADMIN_PASSWORD=admin

EXPOSE 9000
CMD ["/entrypoint.sh"]
