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
  # Pingity Gem was unable to reach the API at the requested endpoint.  The service might be down or, if a manual endpoint was used, it might be configured incorrectly.
  class ServiceUnreachableError < StandardError; end

  # @!visibility private
  # The credentials submitted by the Pingity Gem were rejected by Pingity; please double-check your .env file and ensure PINGITY_ID and PINGITY_SECRET match your API key's 'ID' and 'Secret' respectively.
  class CredentialsError < StandardError; end

  # @!visibility private
  # The request crashes the server.  Stop it.
  class InternalServerError < StandardError; end

  # @!visibility private
  # The server returns a non-JSON object that isn't otherwise caught by its status code.
  class UnexpectedResponseContentError < StandardError; end

  # @!visibility private
  class NoStatusCodeGivenError < StandardError; end

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
