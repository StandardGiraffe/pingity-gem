module Pingity
  class Report
    attr_reader :url

    def initialize(resource, public_key: nil, secret_key: nil, url: nil, eager: false)
      @resource = resource
      @public_key = public_key || Pingity.public_key
      @secret_key = secret_key || Pingity.secret_key

      @url = url ? URI.join(API_URL_BASE, url) : Pingity.url

      if eager
        self.result
      end
    end

    def results?
      !!defined?(@result)
    end

    def status
      self.result[0]["status"]["code"]
    end

    def passed?
      self.status == "pass"
    end

    def failed?
      self.status == "fail_critical"
    end

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