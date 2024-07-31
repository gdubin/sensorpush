# frozen_string_literal: true

require "date"

module Sensorpush
  class Gateway
    attr_accessor :id
    attr_accessor :name
    attr_accessor :version
    attr_accessor :message
    attr_accessor :last_seen
    attr_accessor :last_alert

    def initialize(attributes = {})
      self.id = attributes["id"]
      self.name = attributes["name"]
      self.version = attributes["version"]
      self.message = attributes["message"]
      self.last_seen = DateTime.parse(attributes["last_seen"])
      self.last_alert = DateTime.parse(attributes["last_alert"])
    end
  end
end
