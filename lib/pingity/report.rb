module Pingity
  class Report

    attr_reader :result

    def initialize(resource = nil, public_key: nil, secret_key: nil, url: nil)
      @resource = resource
      @public_key = public_key || Pingity.public_key
      @secret_key = secret_key || Pingity.secret_key
      @url = url || Pingity.url

      @result = JSON.parse((run_report).body)
    end

    def status
      @result[0]["status"]["code"]
    end

    def passed?
      self.status == "pass"
    end

    def failed?
      self.status == "fail_critical"
    end

  private

    def run_report
      con = Faraday.new(url: @url)
      con.basic_auth(@public_key, @secret_key)

      con.post do |req|
        req.headers["Content-type"] = "application/json"
        req.params = { resource: @resource }
      end
    end
  end
end