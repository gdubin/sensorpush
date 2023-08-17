# frozen_string_literal: true

require "date"

module Sensorpush
  class Sample
    attr_accessor :humidity
    attr_accessor :temperature
    attr_accessor :observed

    def initialize(attributes = {})
      self.humidity = attributes["humidity"]
      self.temperature = attributes["temperature"]
      self.observed = DateTime.parse(attributes["observed"])
    end
  end
end
