# frozen_string_literal: true

require "uri"
require "net/http"
require "json"
require "pp"

module Sensorpush
  class Client
    BASE_URL = "https://api.sensorpush.com/api/v1"
    BASE_HEADERS = { 'accept': "application/json", 'Content-Type': "application/json" }.freeze

    attr_accessor :username
    attr_accessor :password
    attr_accessor :accesstoken

    def initialize(options = {})
      self.username = options[:username]
      self.password = options[:password]
      self.accesstoken = options[:accesstoken]
    end

    def authenticate
      authorization = authorize
      self.accesstoken = get_token(authorization) if authorization

      !accesstoken.nil?
    end

    def gateways
      uri = URI(BASE_URL + "/devices/gateways")
      body = {}

      response = Net::HTTP.post(uri, body.to_json, headers)
      json_object = JSON.parse(response.body)

      json_object.collect do |_key, hash|
        Sensorpush::Gateway.new(hash)
      end
    end

    def sensors
      uri = URI(BASE_URL + "/devices/sensors")
      body = {}

      response = Net::HTTP.post(uri, body.to_json, headers)
      json_object = JSON.parse(response.body)

      json_object.collect do |_key, hash|
        Sensorpush::Sensor.new(hash)
      end
    end

    def samples(id, options = {})
      uri = URI(BASE_URL + "/samples")
      body = { sensors: [id] }
      body.merge!({ limit: options[:limit] }) unless options[:limit].nil?
      body.merge!({ startTime: options[:start_time].to_s }) unless options[:start_time].nil?
      body.merge!({ endTime: options[:end_time].to_s }) unless options[:end_time].nil?

      response = Net::HTTP.post(uri, body.to_json, headers)
      json_object = JSON.parse(response.body)

      samples_json_array = json_object.dig("sensors", id)
      samples = samples_json_array&.collect do |hash|
        Sensorpush::Sample.new(hash)
      end
      samples || []
    end

    private

    def headers
      headers = BASE_HEADERS.dup
      headers.merge!({ 'Authorization': accesstoken }) if accesstoken
      headers
    end

    def authorize
      uri = URI(BASE_URL + "/oauth/authorize")
      body = { email: username, password: password }

      response = Net::HTTP.post(uri, body.to_json, headers)
      json_object = JSON.parse(response.body)
      json_object["authorization"]
    end

    def get_token(authorization)
      uri = URI(BASE_URL + "/oauth/accesstoken")
      body = { authorization: authorization }

      response = Net::HTTP.post(uri, body.to_json, headers)
      json_object = JSON.parse(response.body)

      json_object["accesstoken"]
    end
  end
end
