require "bigdecimal"

require "./holding_readers/index"
require_relative "./helpers"

RSpec.describe ETF::BondAsset, "ishares international bond type conversion" do
    let(:reader) { ETF::Scrape::IShares::CSVReader.new }
    let(:lines)  { reader.readlines("spec/holding_readers/ishares_mock_international_bond_assets.csv") }

    it "converts string columns to object values" do
        assert_bond_fields(
            lines[0],
            {
                ticker: "TICKER_1",
                name: "NAME_1",
                sector: "SECTOR_1",
                country_of_risk: "COUNTRY_1",
                exchange: "EXCHANGE_1",
                currency: "CAD",
                market_currency: "USD"
            }
        )

        assert_bond_fields(
            lines[1],
            {
            }
        )
    end

    it "converts numeric columns to object values" do
        assert_bond_fields(
            lines[0],
            {
                weight_percent: BigDecimal.new(11.10, ETF::DEFAULT_PRECISION),
                shares: BigDecimal.new(111_112, ETF::DEFAULT_PRECISION),
                exchange_rate: BigDecimal.new(1.14, ETF::DEFAULT_PRECISION)
            }
        )

        assert_bond_fields(
            lines[1],
            {
                weight_percent: BigDecimal.new(22.20, ETF::DEFAULT_PRECISION),
                shares: BigDecimal.new(222_222, ETF::DEFAULT_PRECISION),
                exchange_rate: BigDecimal.new(2.24, ETF::DEFAULT_PRECISION)
            }
        )
    end

    it "converts CAD currency columns to object values" do
        assert_bond_fields(
            lines[0],
            {
                market_value:   Money.from_amount(1_111_111, "CAD"),
                price:          Money.from_amount(11.13, "CAD"),
                notional_value: Money.from_amount(1_111_111.15, "CAD")
            }
        )
    end

    it "converts USD currency columns to object values" do
        assert_bond_fields(
            lines[1],
            {
                market_value:   Money.from_amount(2_222_221, "USD"),
                price:          Money.from_amount(22.23, "USD"),
                notional_value: Money.from_amount(2_222_222.25, "USD")
            }
        )
    end
end