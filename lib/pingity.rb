require "dotenv/load"
require "faraday"
require "json"

require "pingity/version"
require "pingity/report"

module Pingity
  class Error < StandardError; end

  API_URL = "https://pingity.com/api/v1/reports"
  API_PUBLIC_KEY = ENV['PINGITY_ID']
  API_SECRET_KEY = ENV['PINGITY_SECRET']

  def self.url
    @url || API_URL
  end

  def self.url=(url)
    @url = url
  end

  def self.public_key
    @public_key || API_PUBLIC_KEY
  end

  def self.public_key=(public_key)
    @public_key = public_key
  end

  def self.secret_key
    @secret_key || API_SECRET_KEY
  end

  def self.secret_key=(secret_key)
    @secret_key = secret_key
  end
end
