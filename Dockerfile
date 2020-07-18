FROM ruby:2.5

LABEL maintainer="chris@chrisalley.info"

RUN apt-get update -y && apt-get install -y --no-install-recommends \
  nodejs \
  imagemagick

COPY Gemfile* /cms/
WORKDIR /cms
RUN bundle install

COPY . /cms

# Execute entrypoint script every time the container starts.
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Precompile assets
RUN rake assets:clean
RUN RAILS_ENV=production SECRET_KEY_BASE=abcd1234 rake assets:precompile

# Start the main process.
CMD ["rails", "s", "-b", "0.0.0.0"]
