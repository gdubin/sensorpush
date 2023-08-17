# frozen_string_literal: true

RSpec.describe Sensorpush::Client do
  describe "authenticate" do
    it "retrieves an accesstoken if provided username/password" do
      stub_authorize
      stub_accesstoken

      client = Sensorpush::Client.new({ username: "test@example.com", password: "foobar" })
      expect(client.authenticate).to eq(true)
      expect(client.accesstoken).to eq("mock-accesstoken-123")
    end

    it "returns false if authentication failed" do
      stub_authorize(false)

      client = Sensorpush::Client.new({ username: "test@example.com", password: "foobar" })
      expect(client.authenticate).to eq(false)
    end

    it "returns false if the access token retrieval failed" do
      stub_authorize
      stub_accesstoken(false)

      client = Sensorpush::Client.new({ username: "test@example.com", password: "foobar" })
      expect(client.authenticate).to eq(false)
    end
  end

  describe "sensors" do
    let(:client) { Sensorpush::Client.new({ username: "test@example.com", password: "foobar" }) }

    before(:each) do
      stub_authorize
      stub_accesstoken
    end

    it "returns a list of sensors" do
      stub_sensors(10)

      client.authenticate
      sensors = client.sensors
      expect(sensors.size).to eql(10)
    end

    it "returns an empty list with zero sensors" do
      stub_sensors(0)

      client.authenticate
      sensors = client.sensors
      expect(sensors.size).to eql(0)
    end
  end

  describe "samples" do
    let(:client) { Sensorpush::Client.new({ username: "test@example.com", password: "foobar" }) }

    before(:each) do
      stub_authorize
      stub_accesstoken
    end

    it "returns a list of samples" do
      stub_samples(10)

      client.authenticate
      samples = client.samples("12345.123456")
      expect(samples.size).to eql(10)
    end

    it "returns an empty list with zero samples" do
      stub_samples(0)

      client.authenticate
      samples = client.samples("12345.123456")
      expect(samples.size).to eql(0)
    end

    it "allows caller to specify a limit" do
      stub_request(:post, "https://api.sensorpush.com/api/v1/samples").
        with(
          body: "{\"sensors\":[\"12345.123456\"],\"limit\":10}",
          headers: {
            "Accept" => "application/json",
            "Content-Type" => "application/json"
          }).
        to_return(status: 200, body: "{}", headers: {})

      client.authenticate
      client.samples("12345.123456", { limit: 10 })
    end

    it "allows caller to specify a start time" do
      stub_request(:post, "https://api.sensorpush.com/api/v1/samples").
        with(
          body: "{\"sensors\":[\"12345.123456\"],\"startTime\":\"2023-08-10T05:04:03+00:00\"}",
          headers: {
            "Accept" => "application/json",
            "Content-Type" => "application/json"
          }).
        to_return(status: 200, body: "{}", headers: {})

      client.authenticate
      client.samples("12345.123456", { start_time: DateTime.new(2023, 8, 10, 5, 4, 3) })
    end

    it "allows caller to specify a end time" do
      stub_request(:post, "https://api.sensorpush.com/api/v1/samples").
        with(
          body: "{\"sensors\":[\"12345.123456\"],\"endTime\":\"2023-08-10T05:04:03+00:00\"}",
          headers: {
            "Accept" => "application/json",
            "Content-Type" => "application/json"
          }).
        to_return(status: 200, body: "{}", headers: {})

      client.authenticate
      client.samples("12345.123456", { end_time: DateTime.new(2023, 8, 10, 5, 4, 3) })
    end
  end

  def stub_authorize(successful = true)
    mock_authorize_response = "{}" unless successful
    mock_authorize_response ||= <<~AUTHORIZATION_BODY
      {
        "apikey" : "mock-api-key-1234",
        "authorization" : "mock-authorization-abc-123"
      }
    AUTHORIZATION_BODY

    status = successful ? 200 : 403

    stub_request(:post, "https://api.sensorpush.com/api/v1/oauth/authorize").
      with(
        body: "{\"email\":\"test@example.com\",\"password\":\"foobar\"}",
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }).
      to_return(status: status, body: mock_authorize_response, headers: {})
  end

  def stub_accesstoken(successful = true)
    mock_accesstoken_response = "{}" unless successful
    mock_accesstoken_response ||= <<~ACESSTOKEN_BODY
      {
         "accesstoken" : "mock-accesstoken-123"
      }
    ACESSTOKEN_BODY
    status = successful ? 200 : 400

    stub_request(:post, "https://api.sensorpush.com/api/v1/oauth/accesstoken").
      with(
        body: "{\"authorization\":\"mock-authorization-abc-123\"}",
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }).
      to_return(status: status, body: mock_accesstoken_response, headers: {})
  end

  def stub_sensors(count = 1)
    sensor_jsons = []
    count.times do
      sensor_jsons.push(mock_sensor_json)
    end

    if count > 0
      mock_sensors_response = "{"
      mock_sensors_response += sensor_jsons.join(",")
      mock_sensors_response += "}"
    else
      mock_sensors_response = "{}"
    end

    stub_request(:post, "https://api.sensorpush.com/api/v1/devices/sensors").
      with(
        body: "{}",
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }).
      to_return(status: 200, body: mock_sensors_response, headers: {})
  end

  def stub_samples(count = 1)
    sample_jsons = []
    count.times do
      sample_jsons.push(mock_sample_json)
    end

    mock_samples_response = if count > 0
                              <<~SAMPLES_RESPONSE
                                {
                                   "last_time" : "2023-08-15T15:22:25.000Z",
                                   "sensors" : {
                                      "12345.123456" : [
                                        #{sample_jsons.join(",")}
                                      ]
                                   },
                                   "status" : "OK",
                                   "total_samples" : 10,
                                   "total_sensors" : 1,
                                   "truncated" : false
                                }
                              SAMPLES_RESPONSE
                            else
                              "{}"
                            end

    stub_request(:post, "https://api.sensorpush.com/api/v1/samples").
      with(
        body: "{\"sensors\":[\"12345.123456\"]}",
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }).
      to_return(status: 200, body: mock_samples_response, headers: {})
  end
end
