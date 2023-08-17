# frozen_string_literal: true

require_relative "sensorpush/version"
require_relative "sensorpush/client"
require_relative "sensorpush/sensor"
require_relative "sensorpush/sample"

module Sensorpush
  class Error < StandardError; end

  class << self
    def new(options = {})
      Client.new(options)
    end
  end
end
