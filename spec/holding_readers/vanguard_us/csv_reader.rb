require "bigdecimal"
require "rspec/core"
require "rspec/mocks"

require_relative "../../../holding_readers/index"
require_relative "../helpers"

RSpec.describe ETF::Scrape::Vanguard::US::CSVReader, "type conversion" do
    let(:reader) { ETF::Scrape::Vanguard::US::CSVReader.new }
    let(:blocks)  {
        reader.readlines("spec/holding_readers/vanguard_us/with_mixed_holdings.csv")
    }

    let(:equities) { blocks[0] }
    let(:bonds)    { blocks[1] }

    context "equities" do
        it "converts string columns to object values" do
            assert_equity_fields(
                equities[0],
                {
                    ticker_code: "EQUITY_1",
                    name: "NAME_1",
                    sector: "SECTOR_1",
                    country_of_risk: "COUNTRY_1"
                }
            )

            assert_equity_fields(
                equities[1],
                {
                    ticker_code: "EQUITY_2",
                    name: "NAME_2",
                    sector: "SECTOR_2",
                    country_of_risk: "COUNTRY_2"
                }
            )
        end

        it "converts numeric columns to object values" do
            assert_equity_fields(
                equities[0],
                {
                    weight_percent: BigDecimal.new(1.11111, ETF::DEFAULT_PRECISION),
                    shares: BigDecimal.new(11_111_111, ETF::DEFAULT_PRECISION)
                }
            )

            assert_equity_fields(
                equities[1],
                {
                    weight_percent: BigDecimal.new(2.22222, ETF::DEFAULT_PRECISION),
                    shares: BigDecimal.new(22_222_222, ETF::DEFAULT_PRECISION)
                }
            )
        end

        it "converts CAD currency columns to object values" do
            assert_equity_fields(
                equities[0],
                {
                    market_value:   Money.from_amount(11_111_111.10, "USD")
                }
            )
        end

        it "converts USD currency columns to object values" do
            assert_equity_fields(
                equities[1],
                {
                    market_value:   Money.from_amount(22_222_222.20, "USD")
                }
            )
        end
    end

    context "bonds" do
       it "converts string columns to object values" do
            assert_bond_fields(
                bonds[0],
                {
                    name: "BOND_1"
                }
            )
        end

        it "converts numeric columns to object values" do
            assert_bond_fields(
                bonds[0],
                {
                    yield_to_maturity_percent: BigDecimal(3.33333, ETF::DEFAULT_PRECISION),
                    weight_percent: BigDecimal.new(3.33338, ETF::DEFAULT_PRECISION)
                }
            )
        end

        it "converts currency columns to money values" do
            assert_bond_fields(
                bonds[0],
                {
                    market_value: Money.from_amount(3_333_333.37, "USD")
                }
            )
        end
    end
end