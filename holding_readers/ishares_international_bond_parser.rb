class ETF::InternationalBondAsset
    attr_reader :ticker
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


    def from_ishares(csv_row)
        @ticker,
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
        @notional_value = csv_row[0..14]

        [:weight_percent, :shares, :exchange_rate].each {|key|
            decimal_value = ETF::str_to_decimal(self.send(key))

            self.instance_variable_set("@#{key}", decimal_value)
        }

        [:market_value, :price, :notional_value].each {|key|
            money_value = ETF::str_to_money(self.send(key), @currency)

            self.instance_variable_set("@#{key}", money_value)
        }
    end
end

