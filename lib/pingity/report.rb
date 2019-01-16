module Pingity
  #
  # Class Report encapsulates Pingity reports on specific resources, with built-in query methods for interrogating the results.
  # @author Danny Fekete <danny@postageapp.com>
  class Report
    attr_reader :url

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

        results = con.post do |req|
          req.headers["Content-type"] = "application/json"
          req.params = { resource: @resource }
        end
        JSON.parse((results).body)
      end
    end
  end
end