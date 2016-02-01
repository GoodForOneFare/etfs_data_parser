require_relative "../../../holding_readers/index"

RSpec.describe ETF::Scrape::Vanguard::CA::EquityCSVSanitizer do
    let(:reader) { ETF::Scrape::Vanguard::CA::EquityCSVSanitizer.new }

    it "raises error if CSV file does not exist" do
        expect {
            reader.readlines("unknown_file.csv")
        }.to raise_error(/File not found/)
    end

    it "ignores equity headers" do
        lines = reader.readlines("spec/holding_readers/vanguard_ca/with_equity_headers.csv")
        expect(lines.length).to eq(2)
        expect(lines[0]).to match(/^Apple Inc.,/)
        expect(lines[1]).to match(/^Exxon Mobil Corp.,/)
    end

    it "ignores equity footers" do
        lines = reader.readlines("spec/holding_readers/vanguard_ca/with_equity_footers.csv")
        expect(lines.length).to eq(2)
        expect(lines[0]).to match(/^Taseko Mines Ltd\.,/)
        expect(lines[1]).to match(/^Alvopetro Energy Ltd\.\/CA,/)
    end
end
