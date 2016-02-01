require "money"

# TODO: set this up somewhere that it'll always be initialized.
Money.default_currency = Money::Currency.new("CAD")
Money.default_bank.add_rate("USD", "CAD", 1.38)
Money.use_i18n = false

module ETF
    DEFAULT_PRECISION = 10

    def self.ishares_str_to_date(str_value)
        str_value == "-" ?
            nil :
            Date.strptime(str_value, "%b %d, %Y")
    end

    def self.vanguard_us_str_to_date(str_value)
        str_value == "-" ?
            nil :
            Date.strptime(str_value, "%m/%d/%Y")
    end


    def self.str_to_decimal(str_value)
        return nil if str_value == "-"

        str_value = str_value.sub(/\$/, "").gsub(/,/, "")

        BigDecimal.new(str_value, ETF::DEFAULT_PRECISION)
    end

    def self.str_to_money(str_value, currency_code)
        value = ETF::str_to_decimal(str_value)
        value == nil ?
            nil :
            Money.from_amount(value, currency_code)
    end
end

module ETF::Scrape
    module IShares
    end

    module Vanguard
        module CA end
        module US end
    end
end

require_relative "./ishares_equity_parser"
require_relative "./ishares_bond_parser"
require_relative "./ishares_international_bond_parser"
require_relative "./ishares_real_return_bond_parser"
require_relative "./ishares_csv_sanitizer"
require_relative "./ishares_csv_reader"
require_relative "./vanguard_us/csv_sanitizer"
require_relative "./vanguard_us/csv_reader"
require_relative "./vanguard_ca/bond_csv_sanitizer"
require_relative "./vanguard_ca/equity_csv_sanitizer"
