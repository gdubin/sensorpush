# frozen_string_literal: true

module Sensorpush
  class Sensor
    attr_accessor :active
    attr_accessor :name
    attr_accessor :address
    attr_accessor :battery_voltage
    attr_accessor :id
    attr_accessor :device_id

    def initialize(attributes = {})
      self.active = attributes["active"]
      self.name = attributes["name"]
      self.address = attributes["address"]
      self.battery_voltage = attributes["battery_voltage"]
      self.id = attributes["id"]
      self.device_id = attributes["deviceId"]
    end
  end
end
