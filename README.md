# Sensorpush

This gem will allow you to interface with the [SensorPush Cloud Gateway API](https://www.sensorpush.com/gateway-cloud-api).

SensorPush is a small temperature/humidity sensor.  When paired with the SensorPush Gateway, it enables the gathering of
environmental metrics which are stored and accessed via the SensorPush Cloud Gateway API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sensorpush'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sensorpush

## Usage

After purchasing a SensorPush Gateway and setting it up through the iOS/Android application, you will have a username
and password to access the API.  These credentials are the same as what you would use to access the [SensorPush Dashboard](https://dashboard.sensorpush.com/).

To begin using this gem to retrieve data, you must first authenticate with the service:

```ruby
require 'sensorpush'

client = Sensorpush.new({ username: 'yourusername@example.com', password: 'yourpassword'} )
success = client.authenticate
```

The authenticate method will return true if you've successfully connected to the SensorPush API.

Once you've authenticated you can retrieve a list of sensors by running:

```ruby
sensors = client.sensors
```

This method will return an array of Sensorpush::Sensor objects.  Once you've determined which sensor
you would like to download metrics/samples from, you can query those by using the id of the sensor
and calling:

```ruby
sensor = sensors.first
samples = client.samples(sensor.id)
```

This returns an array of Sensorpush::Sample objects.  The samples method has several options that can be
passed to it to refine which set of samples you would like.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gdubin/sensorpush.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
