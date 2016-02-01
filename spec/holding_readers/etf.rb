require_relative "../../holding_readers/index"

RSpec.describe ETF, "ishares_str_to_date" do
    it "converts strings to dates" do
        expected_date = Date.new(2041, 01, 30)

        expect(ETF::ishares_str_to_date("Jan 30, 2041")).to eq(expected_date)
    end

    it "returns nil for '-' inputs" do
        expect(ETF::ishares_str_to_date("-")).to eq(nil)
    end
end

RSpec.describe ETF, "vanguard_us_str_to_date" do
    it "converts strings to dates" do
        expected_date = Date.new(2041, 01, 30)

        expect(ETF::vanguard_us_str_to_date("01/30/2041")).to eq(expected_date)
    end
end

RSpec.describe ETF, "str_to_decimal" do
    it "returns nil for '-' inputs" do
        expect(ETF::str_to_decimal("-")).to eq(nil)
    end

    it "strips currency symbols" do
        expect(ETF::str_to_decimal("$123")).to eq(BigDecimal.new(123, ETF::DEFAULT_PRECISION))
    end

    it "strips commas" do
        expect(ETF::str_to_decimal("1,123,456")).to eq(BigDecimal.new(1_123_456, ETF::DEFAULT_PRECISION))
    end

    it "keeps decimal points" do
        expect(ETF::str_to_decimal("12.345")).to eq(BigDecimal.new(12.345, ETF::DEFAULT_PRECISION))
    end
end

RSpec.describe ETF, "str_to_money" do
    it "converts to dollars and cents" do
        money = ETF::str_to_money("$901,234,456,789.01", "CAD")
        expect(money.amount).to eq(901_234_456_789.01)
    end

    it "returns nil for '-' inputs" do
        expect(ETF::str_to_money("-", "CAD")).to eq(nil)
    end
end
