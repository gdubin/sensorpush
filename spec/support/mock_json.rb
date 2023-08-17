# frozen_string_literal: true

module MockJson
  def mock_sensor_json(id = nil)
    id ||= rand(10_000..99_999).to_s + "." + rand(100_000..999_999).to_s
    count = rand(1..1000)
    name = "Sensor Name #{count}"

    sensor_json = <<~SENSOR_JSON
      "#{id}" : {
         "active" : true,
         "address" : "C4:11:22:33:7B:44",
         "alerts" : {
            "humidity" : {
               "enabled" : false
            },
            "temperature" : {
               "enabled" : false,
               "max" : 0,
               "min" : 0
            }
         },
         "battery_voltage" : 2.42,
         "calibration" : {
            "humidity" : 0,
            "temperature" : 0
         },
         "deviceId" : "987654",
         "id" : "#{id}",
         "name" : "#{name}",
         "rssi" : -79,
         "type" : "HT1"
      }
    SENSOR_JSON
    sensor_json
  end

  def mock_sample_json
    sample_json = <<~SAMPLE_JSON
      {
          "gateways" : "fs9472jfhgo+hsdhd92374hff",
          "humidity" : 59,
          "observed" : "2023-08-15T15:22:25.000Z",
          "temperature" : 72.25
       }
    SAMPLE_JSON
    sample_json
  end
end
