FROM ruby:2.5

LABEL maintainer="chris@chrisalley.info"

RUN apt-get update -y && apt-get install -y --no-install-recommends \
  nodejs

COPY Gemfile* /app/
WORKDIR /app
RUN bundle install

COPY . /app

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
