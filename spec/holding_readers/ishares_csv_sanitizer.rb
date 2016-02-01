require "bigdecimal"
require "rspec/core"
require "rspec/mocks"

require_relative "../../holding_readers/index"

RSpec.describe ETF::Scrape::IShares::CSVSanitizer do
    let(:reader) { ETF::Scrape::IShares::CSVSanitizer.new }

    it "raises error if CSV file does not exist" do
        expect {
            ETF::Scrape::IShares::CSVSanitizer.new.readlines("unknown_file.csv")
        }.to raise_error(/File not found/)
    end

    it "raises error if column headers not found" do
        expect {
            ETF::Scrape::IShares::CSVSanitizer.new.readlines("spec/holding_readers/ishares_with_no_column_headers.csv")
        }.to raise_error(/Column headers not found/)
    end

    context "equity" do
        it "ignores ETF summary" do
            lines = reader.readlines("spec/holding_readers/ishares_with_equity_headers.csv")
            expect(lines.length).to eq(3)
            expect(lines[1]).to match(/^"CLF",/)
            expect(lines[2]).to match(/^"CDZ",/)
        end

        it "returns column headers in first line" do
            lines = reader.readlines("spec/holding_readers/ishares_with_equity_headers.csv")
            expect(lines[0].strip).to eq(ETF::Scrape::IShares::CSVSanitizer::ISHARES_EQUITY_COLUMNS)
        end

        it "ignores bundled ETF breakdowns" do
            lines = reader.readlines("spec/holding_readers/ishares_with_multiple_etfs.csv")
            expect(lines.length).to eq(3)
            expect(lines[1]).to match(/^"CLF",/)
            expect(lines[2]).to match(/^"CDZ",/)
        end
    end

    context "bond" do
        it "ignores ETF summary" do
            lines = reader.readlines("spec/holding_readers/ishares_with_bond_headers.csv")
            expect(lines.length).to eq(3)
            expect(lines[1]).to match(/^"CANADA/)
            expect(lines[2]).to match(/^"ONTARIO/)
        end

        it "returns column headers in first line" do
            lines = reader.readlines("spec/holding_readers/ishares_with_bond_headers.csv")
            expect(lines[0].strip).to eq(ETF::Scrape::IShares::CSVSanitizer::ISHARES_BOND_COLUMNS)
        end
    end

    context "international bond" do
        it "ignores ETF summary" do
            lines = reader.readlines("spec/holding_readers/ishares_with_international_bond_headers.csv")
            expect(lines.length).to eq(3)
            expect(lines[1]).to match(/^"CHL",/)
            expect(lines[2]).to match(/^"BIDU",/)
        end

        it "returns column headers in first line" do
            lines = reader.readlines("spec/holding_readers/ishares_with_international_bond_headers.csv")
            expect(lines[0].strip).to eq(ETF::Scrape::IShares::CSVSanitizer::ISHARES_INTERNATIONAL_BOND_COLUMNS)
        end
    end
end
