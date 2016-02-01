require "bigdecimal"

require "./holding_readers/index"
require_relative "./helpers"

# TODO: use shared groups to merge in regular bond tests here (https://www.relishapp.com/rspec/rspec-core/docs/example-groups/shared-examples).
RSpec.describe ETF::BondAsset, "ishares real return bond type conversion" do
    let(:reader) { ETF::Scrape::IShares::CSVReader.new }
    let(:lines)  { reader.readlines("spec/holding_readers/ishares_mock_real_return_bond_assets.csv") }

    it "converts string columns to object values" do
        assert_bond_fields(
            lines[0],
            {
                name: "NAME_1",
                country_of_risk: "COUNTRY_1",
                sector: "SECTOR_1",
                asset_class: "ASSET_CLASS_1",
                currency: "CAD",
                market_currency: "USD"
            }
        )

        assert_bond_fields(
            lines[1],
            {
                name: "NAME_2",
                country_of_risk: "COUNTRY_2",
                sector: "SECTOR_2",
                asset_class: "ASSET_CLASS_2",
                currency: "USD",
                market_currency: "CAD"
            }
        )
    end

    it "converts numeric columns to object values" do
        assert_bond_fields(
            lines[0],
            {
                weight_percent: BigDecimal.new(11.10, ETF::DEFAULT_PRECISION),
                coupon_percent: BigDecimal.new(1.12, ETF::DEFAULT_PRECISION),
                duration: BigDecimal.new(11.13, ETF::DEFAULT_PRECISION),
                exchange_rate: BigDecimal.new(1.15, ETF::DEFAULT_PRECISION),
                real_yield_to_maturity_percent: BigDecimal.new(1.17, ETF::DEFAULT_PRECISION),
                yield_to_maturity_percent: BigDecimal.new(1.18, ETF::DEFAULT_PRECISION),
                yield_to_call_percent: nil,
                yield_to_worst_percent: BigDecimal.new(1.19, ETF::DEFAULT_PRECISION),
            }
        )

        assert_bond_fields(
            lines[1],
            {
                weight_percent: BigDecimal.new(22.20, ETF::DEFAULT_PRECISION),
                coupon_percent: BigDecimal.new(2.22, ETF::DEFAULT_PRECISION),
                duration: BigDecimal.new(22.23, ETF::DEFAULT_PRECISION),
                exchange_rate: BigDecimal.new(2.25, ETF::DEFAULT_PRECISION),
                real_yield_to_maturity_percent: BigDecimal.new(2.27, ETF::DEFAULT_PRECISION),
                yield_to_maturity_percent: BigDecimal.new(2.28, ETF::DEFAULT_PRECISION),
                yield_to_call_percent: nil,
                yield_to_worst_percent: BigDecimal.new(2.19, ETF::DEFAULT_PRECISION),
            }
        )
    end

    it "converts CAD currency columns to object values" do
        assert_bond_fields(
            lines[0],
            {
                market_value:   Money.from_amount(11_111_111, "CAD"),
                price:          Money.from_amount(111.14, "CAD"),
                notional_value: Money.from_amount(11_111_111.10, "CAD")
            }
        )
    end

    it "converts USD currency columns to object values" do
        assert_bond_fields(
            lines[1],
            {
                market_value:   Money.from_amount(22_222_221, "USD"),
                price:          Money.from_amount(222.24, "USD"),
                notional_value: Money.from_amount(22_222_222.20, "USD")
            }
        )
    end

    it "converts date columns to object values" do
        assert_bond_fields(
            lines[0], { maturity: Date.new(2041, 01, 01) }
        )

        assert_bond_fields(
            lines[1], { maturity: Date.new(2042, 02, 02) }
        )
    end
end