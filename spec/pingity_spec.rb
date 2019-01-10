RSpec.describe Pingity do
  it "has a version number" do
    expect(Pingity::VERSION).not_to be nil
  end

  it "requires Faraday correctly" do
    expect(Faraday).to eq(Faraday)
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
