class ETF::EquityAsset
    attr_reader :ticker_code
    attr_reader :name
    attr_reader :weight_percent
    attr_reader :sector
    attr_reader :country_of_risk
    attr_reader :market_value
    attr_reader :shares
    attr_reader :price
    attr_reader :exchange
    attr_reader :currency
    attr_reader :market_currency
    attr_reader :exchange_rate
    attr_reader :notional_value

    def from_vanguard(csv_row)
        @name,
        @ticker_code,
        @weight_percent = csv_row
    end

    def from_ishares(csv_row)
        @ticker_code,
        @cusip,
        @sedol,
        @name,
        @weight_percent,
        @sector,
        @country_of_risk,
        @market_value,
        @shares,
        @price,
        @exchange,
        @currency,
        @market_currency,
        @exchange_rate,
        @notional_value = csv_row

        [:weight_percent, :shares, :exchange_rate].each {|key|
            decimal_value = ETF::str_to_decimal(self.send(key))

            self.instance_variable_set("@#{key}", decimal_value)
        }

        [:market_value, :price, :notional_value].each {|key|
            money_value = ETF::str_to_money(self.send(key), @currency)

            self.instance_variable_set("@#{key}", money_value)
        }
    end

    def from_vanguard_us(csv_row)
        _,
        @sedol,
        @ticker_code,
        @name,
        @shares,
        @market_value,
        @weight_percent,
        @sector,
        @country_of_risk,
        @security_depository_receipt_type = csv_row

        @sedol = @sedol.sub(/[="]/, "")
        @ticker_code = @ticker_code.strip
        @country_of_risk = @country_of_risk.strip

        @shares = ETF::str_to_decimal(@shares)
        @weight_percent = ETF::str_to_decimal(@weight_percent)
        @market_value = ETF::str_to_money(@market_value, "USD")
    end
end
