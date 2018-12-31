FROM ruby:2.5

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends nodejs

COPY . /app

WORKDIR /app
RUN bundle install
