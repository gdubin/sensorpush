# frozen_string_literal: true

require "json"

RSpec.describe Sensorpush::Gateway do
  describe "new" do
    let(:gateway_list_json) { mock_gateway_list_json }

    it "takes a hash of values and sets the attributes accordingly" do
      raw_list_data = JSON.parse(gateway_list_json)
      raw_object_data = raw_list_data["Gateway"]

      gateway = Sensorpush::Gateway.new(raw_object_data)

      expect(gateway.id).to eql(raw_object_data["id"])
    end
  end
end
