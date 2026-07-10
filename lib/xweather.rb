# frozen_string_literal: true

require_relative "xweather/version"
require_relative "xweather/configuration"
require_relative "xweather/lightning_flash"
require_relative "xweather/lightning"
require_relative "xweather/lightning_analytics"
require_relative "xweather/lightning_threats"
require_relative "xweather/client"

module Xweather
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
    Client.reset_connection!
  end
end
