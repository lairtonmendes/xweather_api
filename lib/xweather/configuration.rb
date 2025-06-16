# frozen_string_literal: true

require "faraday"

# Xweather is a module for integrating with the Xweather API.
# This module contains classes and methods for configuring the connection to the service.
module Xweather
  # Configuration class for managing connection settings to the Xweather API.
  #
  # Example usage:
  #   config = Xweather::Configuration.new
  #   config.endpoint = "https://your-endpoint.com/"
  #   config.client_id = "your_client_id"
  #   config.client_secret = "your_client_secret"
  #
  class Configuration
    # The base URL of the Xweather API.
    # @return [String]
    attr_accessor :endpoint

    # Client ID used for API authentication.
    # @return [String, nil]
    attr_accessor :client_id

    # Client secret used for API authentication.
    # @return [String, nil]
    attr_accessor :client_secret

    # Faraday adapter to be used for HTTP requests.
    # @return [Symbol]
    attr_accessor :faraday_adapter

    # Enables or disables caching of API responses.
    # @return [Boolean]
    attr_accessor :cache

    # Cache expiration time in seconds.
    # @return [Integer]
    attr_accessor :cache_expires_in

    # Initializes the configuration with default values.
    #
    # @return [Xweather::Configuration]
    def initialize
      @endpoint = "https://data.api.xweather.com/"
      @client_id = nil
      @client_secret = nil
      @faraday_adapter = Faraday.default_adapter
      @cache = false
      @cache_expires_in = 600
    end
  end
end
