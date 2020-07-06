FROM bitnami/rails:latest
MAINTAINER Darren Cauthon <darren@cauthon.com>

ADD overt /app

USER bitnami

CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]