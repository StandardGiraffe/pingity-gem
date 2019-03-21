module Pingity
  #
  # Class Report encapsulates Pingity reports on specific resources, with built-in query methods for interrogating the results.
  # @author Danny Fekete <danny@postageapp.com>
  class Report
    attr_reader :url
    require 'time'

    #
    # Initializes a new Report object
    #
    # @param [String] resource Takes an email or web address as the report subject.
    # @param [String] public_key Optionally provide the Pingity API ID (usually specified in the .env)
    # @param [String] secret_key Optionally provide the Pingity API Secret (usually specified in the .env)
    # @param [String] url Optionally provide an alternative API endpoint
    # @param [Boolean] eager Optionally run the Pingity report as soon as the object is instantiated (normally, the report is run the first time details are requested)
    def initialize(resource, public_key: nil, secret_key: nil, url: nil, eager: false)
      @resource = resource
      @public_key = public_key || Pingity.public_key
      @secret_key = secret_key || Pingity.secret_key

      @url = url ? URI.join(API_URL_BASE, url) : Pingity.url

      if eager
        self.result
      end
    end

    #
    # Checks whether the object has run and recorded its results yet.  (Normally, Report objects will only collect results when first asked for them.)
    # @return [Boolean] Returns true if the object contains results.
    def results?
      !!defined?(@result)
    end

    #
    # Checks the target of the report object.  (Runs the report if results are not already recorded.)
    #
    # @return [String] Returns the target URI against which the test was run.  The URI will have been canonized by Pingity at this point.
    #
    def target
      self.result[0]["target"]
    end

    #
    # Checks the timestamp of the report object.  (Runs the report if results are not already recorded.)
    #
    # @return [Time] Returns the time at which the result was run by Pingity.
    #
    def timestamp
      Time.parse(self.result[0]["timestamp"])
    end

    #
    # Checks the resource type of the report object.  (Runs the report if results are not already recorded.)
    #
    # @return [String] Returns the resource type of the URI against which the test was run, as identified by Pingity.
    #
    def resource_type
      self.result[0]["resource_type"]
    end

    #
    # Checks overall status of the report object.  (Runs the report if results are not already recorded.)
    # @return [String] Returns the overall status code of the report results.
    def status
      self.result[0]["status"]["code"]
    end

    #
    # Checks whether the resource has passed its Pingity test.  (Runs the report if results are not already recorded.)
    # @return [Boolean] true if the overall status code is "pass"
    def passed?
      self.status == "pass"
    end

    #
    # Checks whether the resource has passed its Pingity test.  (Runs the report if results are not already recorded.)
    # @return [Boolean] true if the overall status code is "fail_critical"
    def failed?
      self.status == "fail_critical"
    end

    #
    # Dumps the results of the Pingity test for the resource.  (Runs the report if results are not already recorded.)
    # @return [Array(Hash)] of the results.
    def result
      @result ||= begin
        con = Faraday.new(url: @url)
        con.basic_auth(@public_key, @secret_key)

        res = con.post do |req|
          req.headers["Content-type"] = "application/json"
          req.params = { resource: @resource }
        end

        # response_interrogator(res)

        case res.status
        when 500
          raise Pingity::InternalServerError, "Request could not be processed."
        when 401
          raise Pingity::CredentialsError, "Submitted credentials were rejected."
        when 200
          case res.headers["Content-type"].to_s.split(';').first
          when "application/json"
            JSON.parse(res.body)
          else
            raise Pingity::UnexpectedResponseContentError, "Service returned unexpected content type: #{res.headers["Content-type"]}"
          end
        else
          raise response_as_exception(res)
        end

      rescue Faraday::ConnectionFailed => e
        raise Pingity::ServiceUnreachableError, "Unable to reach the API at the requested endpoint: #{Pingity::API_URL}; #{e.message}"
      end
    end

  protected

    # @!visibility private
    def response_as_exception(res)
      case res.headers["Content-type"].to_s.split(';').first
      when "application/json"
        body = JSON.parse(res.body)

        # case on body content when examples arise.  Until then...
        Pingity::NoStatusCodeGivenError.new("(Until specific cases arise...) No status code was given in the API call response.  Weird.")
      else
        Pingity::UnexpectedResponseContentError.new("Service returned unexpected content type: #{res.headers["Content-type"]}")
      end
    end

    # @!visibility private
    def response_interrogator(res)
      puts "*****************************"
      puts "Response code:"
      p res.status
      puts "Response headers:"
      p res.headers
      puts "Response body:"
      p res.body
      puts "*****************************"
    end
  end
end
