# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.2.0
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

# Install base dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      libpq-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN gem install bundler -v 2.5.21

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    MALLOC_ARENA_MAX=2 \
    RAILS_LOG_TO_STDOUT="1" \
    PATH="/usr/local/bundle/bin:$PATH"

# Build Stage
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 4 --retry 5

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets
RUN RAILS_ENV=production RAILS_SERVE_STATIC_FILES=1 SECRET_KEY_BASE=nonempty bundle exec rails assets:precompile

# Runtime Stage
FROM base

# Create a non-root user before copying
RUN groupadd --system rails && \
    useradd --system --create-home --gid rails rails

COPY --chown=rails:rails --from=build /usr/local/bundle /usr/local/bundle
COPY --chown=rails:rails --from=build /app /app

COPY --chown=rails:rails --from=build /app/bin/docker-entrypoint /app/bin/docker-entrypoint
RUN chmod +x /app/bin/docker-entrypoint

USER rails

ENTRYPOINT ["/app/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
