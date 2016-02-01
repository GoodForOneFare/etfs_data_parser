class ETF::ETFAsset
    attr_reader :ticker_code
    attr_reader :name
    attr_reader :inception_date
    attr_reader :market_value
    attr_reader :shares

    def from_vanguard()

    end

    def from_ishares(header_lines, rows)
        @name,
        @inception_date,
        @date,
        @market_value,
        @shares = header_lines.map(&:strip)

        @rows = rows
    end

    def from_vanguard_us()

    end
end
