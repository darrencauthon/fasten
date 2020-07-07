FROM bitnami/rails:latest
MAINTAINER Darren Cauthon <darren@cauthon.com>

COPY overt /app

RUN bundle install

CMD [ "bundle", "exec", "sidekiq" ]