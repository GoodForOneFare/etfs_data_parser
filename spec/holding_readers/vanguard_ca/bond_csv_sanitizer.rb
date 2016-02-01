require_relative "../../../holding_readers/index"

RSpec.describe ETF::Scrape::Vanguard::CA::EquityCSVSanitizer do
    let(:reader) { ETF::Scrape::Vanguard::CA::BondCSVSanitizer.new }

    it "raises error if CSV file does not exist" do
        expect {
            reader.readlines("unknown_file.csv")
        }.to raise_error(/File not found/)
    end

    it "ignores bond headers" do
        lines = reader.readlines("spec/holding_readers/vanguard_ca/with_bond_headers.csv")
        expect(lines.length).to eq(2)
        expect(lines[0]).to match(/^Canadian Government Bond,/)
        expect(lines[1]).to match(/^Province of Ontario Canada,/)
    end

    it "ignores bond footers" do
        lines = reader.readlines("spec/holding_readers/vanguard_ca/with_bond_footers.csv")
        expect(lines.length).to eq(2)

        expect(lines[0]).to match(/^Manulife Financial Corp.,/)
        expect(lines[1]).to match(/^Bank of America Corp.,/)
    end
end
