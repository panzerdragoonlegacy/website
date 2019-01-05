FROM ruby:2.5

LABEL maintainer="chris@chrisalley.info"

RUN apt-get update -y && apt-get install -y --no-install-recommends \
  nodejs

COPY Gemfile* /app/
WORKDIR /app
RUN bundle install

COPY . /app

# Execute entrypoint script every time the container starts.
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Start the main process.
CMD ["rails", "s", "-b", "0.0.0.0"]
