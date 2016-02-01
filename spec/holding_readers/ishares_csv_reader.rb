require "bigdecimal"
require "rspec/core"
require "rspec/mocks"

require_relative "../../holding_readers/index"
require_relative "./helpers"

RSpec.describe ETF::Scrape::IShares::CSVReader, "equity type conversion" do
    let(:reader) { ETF::Scrape::IShares::CSVReader.new }
    let(:lines)  {
        reader.readlines("spec/holding_readers/ishares_simple_mock_equity_assets.csv")
    }

    it "converts string columns to object values" do
        assert_equity_fields(
            lines[0],
            {
                ticker_code: "TICKER_1",
                name: "NAME_1",
                sector: "SECTOR_1",
                country_of_risk: "COUNTRY_1",
                exchange: "EXCHANGE_1",
                currency: "CAD",
                market_currency: "CAD"
            }
        )

        assert_equity_fields(
            lines[1],
            {
                ticker_code: "TICKER_2",
                name: "NAME_2",
                sector: "SECTOR_2",
                country_of_risk: "COUNTRY_2",
                exchange: "EXCHANGE_2",
                currency: "USD",
                market_currency: "USD"
            }
        )
    end

    it "converts numeric columns to object values" do
        assert_equity_fields(
            lines[0],
            {
                weight_percent: BigDecimal.new(11.11, ETF::DEFAULT_PRECISION),
                shares: BigDecimal.new(111_111, ETF::DEFAULT_PRECISION),
                exchange_rate: BigDecimal.new(1.11, ETF::DEFAULT_PRECISION)
            }
        )

        assert_equity_fields(
            lines[1],
            {
                weight_percent: BigDecimal.new(22.22, ETF::DEFAULT_PRECISION),
                shares: BigDecimal.new(222_222, ETF::DEFAULT_PRECISION),
                exchange_rate: BigDecimal(2.22, ETF::DEFAULT_PRECISION)
            }
        )
    end

    it "converts CAD currency columns to object values" do
        assert_equity_fields(
            lines[0],
            {
                market_value:   Money.from_amount(11_111_111, "CAD"),
                price:          Money.from_amount(10.10, "CAD"),
                notional_value: Money.from_amount(11_111_111.11, "CAD")
            }
        )
    end

    it "converts USD currency columns to object values" do
        assert_equity_fields(
            lines[1],
            {
                market_value:   Money.from_amount(22_222_222, "USD"),
                price:          Money.from_amount(20.20, "USD"),
                notional_value: Money.from_amount(22_222_222.22, "USD")
            }
        )
    end
end