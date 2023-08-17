# frozen_string_literal: true

RSpec.describe Sensorpush do
  it "has a version number" do
    expect(Sensorpush::VERSION).not_to be nil
  end

  it "new to return a populated SensorPush::Client" do
    client = Sensorpush.new({ username: "test@example.com", password: "foobar" })
    expect(client.username).to eq("test@example.com")
    expect(client.password).to eq("foobar")
  end
end
