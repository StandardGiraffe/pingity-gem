require "dotenv/load"
require "faraday"
require "json"
require "uri"

require "pingity/version"
require "pingity/report"

module Pingity
  class Error < StandardError; end

  API_URL_BASE = ENV['PINGITY_API_BASE'] || "https://pingity.com/"
  API_URL_ENDPOINT = "/api/v1/reports"
  API_URL = URI.join(API_URL_BASE, API_URL_ENDPOINT).to_s.freeze
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
