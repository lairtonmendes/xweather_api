# frozen_string_literal: true

require "json"

module Xweather
  # Provides access to Vaisala Xweather's global lightning flash data using the :id action.
  #
  # Example usage:
  #   # By coordinates
  #   Xweather::Lightning.by_coords(lat: 37.7749, lon: -122.4194)
  #
  #   # By generic identifier
  #   Xweather::Lightning.by_id("san Francisco,fl")
  #
  class Lightning
    # Retrieves lightning data for a specific identifier.
    #
    # @param id [String] The identifier (e.g., "lat,lon", city name, postal code, or endpoint-specific ID).
    # @param options [Hash] Optional query parameters.
    # @return [Array<Hash>] Array of lightning flash data hashes.
    def self.by_id(id, options = {})
      response = Client.get("lightning/#{id}", **options)
      JSON.parse(response.body)
    end

    # Retrieves lightning data by coordinates (latitude, longitude).
    #
    # @param lat [Float, String] Latitude.
    # @param lon [Float, String] Longitude.
    # @param options [Hash] Optional query parameters.
    # @return [Array<Hash>] Array of lightning data hashes.
    def self.by_coords(lat:, lon:, **options)
      id = "#{lat},#{lon}"
      by_id(id, options)
    end
  end
end
