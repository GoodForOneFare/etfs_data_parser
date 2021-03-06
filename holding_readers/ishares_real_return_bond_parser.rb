class ETF::RealReturnBondAsset
    attr_reader :name
    attr_reader :weight_percent
    attr_reader :market_value
    attr_reader :country_of_risk
    attr_reader :sector
    attr_reader :coupon_percent
    attr_reader :maturity
    attr_reader :duration
    attr_reader :price
    attr_reader :asset_class
    attr_reader :currency
    attr_reader :market_currency
    attr_reader :exchange_rate
    attr_reader :mod_duration
    attr_reader :real_yield_to_maturity_percent
    attr_reader :yield_to_maturity_percent
    attr_reader :yield_to_call_percent
    attr_reader :yield_to_worst_percent
    attr_reader :notional_value


    def from_ishares(csv_row)
        @name,
        @cusip,
        @sedol,
        @weight_percent,
        @market_value,
        @country_of_risk,
        @sector,
        @coupon_percent,
        @maturity,
        @duration,
        @price,
        @asset_class,
        @currency,
        @market_currency,
        @exchange_rate,
        @mod_duration,
        @real_yield_to_maturity_percent,
        @yield_to_maturity_percent,
        @yield_to_call_percent,
        @yield_to_worst_percent,
        @notional_value = csv_row[0..csv_row.length]

        [:weight_percent, :coupon_percent, :duration, :exchange_rate, :mod_duration, :real_yield_to_maturity_percent, :yield_to_maturity_percent, :yield_to_call_percent, :yield_to_worst_percent].each {|key|
            decimal_value = ETF::str_to_decimal(self.send(key))

            self.instance_variable_set("@#{key}", decimal_value)
        }

        [:market_value, :price, :notional_value].each {|key|
            money_value = ETF::str_to_money(self.send(key), @currency)

            self.instance_variable_set("@#{key}", money_value)
        }

        @maturity = ETF::ishares_str_to_date(@maturity)
    end
end

