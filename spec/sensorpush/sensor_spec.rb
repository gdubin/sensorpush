# frozen_string_literal: true

require "json"

RSpec.describe Sensorpush::Sensor do
  describe "new" do
    let(:sensor_json) { "{" + mock_sensor_json("1234.1234") + "}" }

    it "takes a hash of values and sets the attributes accordingly" do
      json_list = JSON.parse(sensor_json)
      json_sensor = json_list["1234.1234"]
      sensor = Sensorpush::Sensor.new(json_sensor)

      expect(sensor.id).to eql("1234.1234")
      expect(sensor.name).to eql(json_sensor["name"])
      expect(sensor.active).to eql(json_sensor["active"])
      expect(sensor.address).to eql(json_sensor["address"])
      expect(sensor.battery_voltage).to eql(json_sensor["battery_voltage"])
      expect(sensor.device_id).to eql(json_sensor["deviceId"])
    end
  end
end
