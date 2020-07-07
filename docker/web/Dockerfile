FROM bitnami/rails:latest
MAINTAINER Darren Cauthon <darren@cauthon.com>

COPY overt /app

RUN bundle install

CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]