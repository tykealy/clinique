# syntax = docker/dockerfile:1

# Base Image
ARG RUBY_VERSION=3.2.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set working directory
WORKDIR /app

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      sqlite3 \
      libpq-dev \
      && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install Bundler
RUN gem install bundler -v 2.5.21

# Set environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    PATH="/usr/local/bundle/bin:$PATH"

# Build Stage
FROM base AS build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      pkg-config \
      && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 5

# Copy application code
COPY . .

# Precompile bootsnap code
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets without requiring SECRET_KEY_BASE
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Final Stage
FROM base

# Copy built gems and application code
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# Copy entrypoint script
COPY --from=build /app/bin/docker-entrypoint /app/bin/docker-entrypoint

# Make entrypoint script executable
RUN chmod +x /app/bin/docker-entrypoint

# Create a non-root user and set ownership
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /app/db /app/log /app/storage /app/tmp /app/bin/docker-entrypoint

# Switch to the non-root user
USER rails:rails

# Entrypoint
ENTRYPOINT ["/app/bin/docker-entrypoint"]

# Expose port 3000
EXPOSE 3000

# Default command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
