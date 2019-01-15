RSpec.describe Pingity do
  it "has a version number" do
    expect(Pingity::VERSION).not_to be nil
  end

  it "requires Faraday correctly" do
    expect(Faraday).to eq(Faraday)
  end

  context "can run reports..." do
    context "with an email address" do
      valid_email_report = Pingity::Report.new("danny@postageapp.com")
      invalid_email_report = Pingity::Report.new("garbage.email@missing.whatever")

      it "as a resource subject" do
        expect(valid_email_report.result).not_to be nil
        expect(invalid_email_report.result).not_to be nil
      end

      it "that register correct statuses" do
        expect(valid_email_report.status).to eq("warning")
        expect(invalid_email_report.status).to eq("fail_critical")
      end

      it "that respond correctly to .passed? and .failed? methods" do
        expect(valid_email_report.passed?).to eq(false)
        expect(valid_email_report.failed?).to eq(false)
        expect(invalid_email_report.passed?).to eq(false)
        expect(invalid_email_report.failed?).to eq(true)
      end
    end

    context "with a web address" do
      valid_web_report = Pingity::Report.new("philomathy.org")
      invalid_web_report = Pingity::Report.new("a08b2nb972n.tooth")

      it "as a resource subject" do
        expect(valid_web_report.result).not_to be nil
        expect(invalid_web_report.result).not_to be nil
      end

      it "that register correct statuses" do
        expect(valid_web_report.status).to eq("pass")
        expect(invalid_web_report.status).to eq("fail_critical")
      end

      it "that respond correctly to .passed? and .failed? methods" do
        expect(valid_web_report.passed?).to eq(true)
        expect(valid_web_report.failed?).to eq(false)
        expect(invalid_web_report.passed?).to eq(false)
        expect(invalid_web_report.failed?).to eq(true)
      end
    end
  end
end
