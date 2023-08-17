# frozen_string_literal: true

require "json"

RSpec.describe Sensorpush::Sample do
  describe "new" do
    let(:sample_json) { mock_sample_json }

    it "takes a hash of values and sets the attributes accordingly" do
      json_sample = JSON.parse(sample_json)
      sample = Sensorpush::Sample.new(json_sample)

      expect(sample.humidity).to eql(json_sample["humidity"])
      expect(sample.temperature).to eql(json_sample["temperature"])

      expect(sample.observed.year).to eql(2023)
      expect(sample.observed.month).to eql(8)
      expect(sample.observed.day).to eql(15)
      expect(sample.observed.hour).to eql(15)
      expect(sample.observed.minute).to eql(22)
      expect(sample.observed.second).to eql(25)
    end
  end
end
