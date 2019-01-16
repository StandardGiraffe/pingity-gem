require "dotenv/load"
require "faraday"
require "json"
require "uri"

require "pingity/version"
require "pingity/report"

#
# Module Pingity manages environmental variables and default settings for the Report Class.
#
# @author Danny Fekete <danny@postageapp.com>
#
module Pingity
  # @!visibility private
  class Error < StandardError; end

  # @!visibility private
  API_URL_BASE = ENV['PINGITY_API_BASE'] || "https://pingity.com/"

  # @!visibility private
  API_URL_ENDPOINT = "/api/v1/reports"

  # @!visibility private
  API_URL = URI.join(API_URL_BASE, API_URL_ENDPOINT).to_s.freeze

  # @!visibility private
  API_PUBLIC_KEY = ENV['PINGITY_ID']

  # @!visibility private
  API_SECRET_KEY = ENV['PINGITY_SECRET']

  #
  # @return [String] the API endpoint.
  def self.url
    @url || API_URL
  end

  #
  # Overrides the API endpoint.
  # @return [String] the overridden API endpoint.
  def self.url=(url)
    @url = url
  end

  #
  # @return [String] the Pingity API ID, specified in the .env file
  def self.public_key
    @public_key || API_PUBLIC_KEY
  end

  #
  # Overrides the Pingity API ID specified in the .env file
  # @return [String] the overridden API ID
  def self.public_key=(public_key)
    @public_key = public_key
  end

  #
  # @return [String] the Pingity API Secret, specified in the .env file
  def self.secret_key
    @secret_key || API_SECRET_KEY
  end

  #
  # Overrides the Pingity API Secret specified in the .env file
  # @return [String] the overridden API Secret
  def self.secret_key=(secret_key)
    @secret_key = secret_key
  end
end
