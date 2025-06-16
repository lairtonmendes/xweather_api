# frozen_string_literal: true

require "faraday"
require "digest"

# Xweather module provides integration with the Xweather API.
module Xweather
  # Client class responsible for making requests to the Xweather API.
  # It supports optional response caching using Rails.cache.
  class Client
    class << self
      # Returns a persistent Faraday connection configured for Xweather.
      #
      # @return [Faraday::Connection] The configured Faraday connection.
      def connection
        @connection ||= Faraday.new do |conn|
          conn.url_prefix = Xweather.configuration.endpoint
          conn.request :json
          conn.adapter Xweather.configuration.faraday_adapter
        end
      end

      # Makes a GET request to the Xweather API, automatically including client credentials.
      # Optionally uses caching if enabled in configuration and Rails cache is present.
      #
      # @param args [Array] Arguments passed to Faraday's get method (typically the path).
      # @param kwargs [Hash] Keyword arguments for Faraday's get method (query parameters, etc).
      # @return [Faraday::Response, Object] The API response, or cached data if available.
      def get(*args, **kwargs)
        kwargs[:client_id] = Xweather.configuration.client_id
        kwargs[:client_secret] = Xweather.configuration.client_secret

        if use_cache?
          key = cache_key(*args, **kwargs)
          cached = Rails.cache.read(key)

          if cached
            log_cache_hit(*args, **kwargs)
            cached
          else
            Rails.cache.fetch(key, expires_in: Xweather.configuration.cache_expires_in) do
              connection.get(*args, **kwargs)
            end
          end
        else
          connection.get(*args, **kwargs)
        end
      end

      private

      # Logs when a cached response is used, if Rails logger is available.
      #
      # @param args [Array] Path and other positional arguments.
      # @param kwargs [Hash] Query parameters, etc.
      def log_cache_hit(*args, **kwargs)
        return unless defined?(Rails) && Rails.logger

        path = args[0]
        params = kwargs.except(:appid)
        Rails.logger.info("[Xweather] Cache HIT path #{path}, params: #{params}")
      end

      # Determines if caching should be used based on configuration and Rails cache presence.
      #
      # @return [Boolean] True if caching is enabled and Rails cache is available.
      def use_cache?
        Xweather.configuration.cache &&
          defined?(Rails) &&
          Rails.respond_to?(:cache) &&
          Rails.cache.present?
      end

      # Generates a unique cache key for a given request based on arguments.
      #
      # @param args [Array] Path and other positional arguments.
      # @param kwargs [Hash] Query parameters, etc.
      # @return [String] The generated cache key.
      def cache_key(*args, **kwargs)
        raw_key = { args: args, kwargs: kwargs.except(:appid) }.inspect
        "xweather:#{Digest::SHA256.hexdigest(raw_key)}"
      end
    end
  end
end
