module Pingity
  class Report

    attr_reader :result

    def initialize(resource = nil, public_key: API_PUBLIC_KEY, secret_key: API_SECRET_KEY, url: API_URL)
      @resource = resource
      @public_key = public_key
      @secret_key = secret_key
      @url = url

      @result = JSON.parse((run_report).body)
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