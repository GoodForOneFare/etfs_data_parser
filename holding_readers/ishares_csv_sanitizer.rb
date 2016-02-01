class ETF::Scrape::IShares::CSVSanitizer

    ISHARES_EQUITY_COLUMNS = "Ticker,ISIN,SEDOL,Name,Weight (%),Sector,Country of Risk,Market Value,Shares,Price,Exchange,Currency,Market Currency,FX Rate,Notional Value"
    ISHARES_BOND_COLUMNS   = "Name,CUSIP,SEDOL,Weight (%),Market Value,Country of Risk,Sector,Coupon (%),Maturity,Duration,Price,Asset Class,Currency,Market Currency,FX Rate,Mod. Duration,YTM (%),Yield to Call (%),Yield to Worst (%),Notional Value"
    ISHARES_INTERNATIONAL_BOND_COLUMNS = "Ticker,CUSIP,SEDOL,Name,Weight (%),Sector,Country of Risk,Market Value,Shares,Price,Exchange,Currency,Market Currency,FX Rate,Notional Value"
    ISHARES_REAL_RETURN_BOND_COLUMNS = "Name,CUSIP,SEDOL,Weight (%),Market Value,Country of Risk,Sector,Coupon (%),Maturity,Duration,Price,Asset Class,Currency,Market Currency,FX Rate,Mod. Duration,Real YTM (%),YTM (%),Yield to Call (%),Yield to Worst (%),Notional Value"

    # VANGUARD_CA_EQUITY_HEADER = "Securities,Symbol,% of assets*"
    # VANGUARD_CA_BOND_HEADER = "Securities,Rate,Maturity date,% of assets*"

    HEADERS = [
        ISHARES_EQUITY_COLUMNS,
        ISHARES_BOND_COLUMNS,
        ISHARES_INTERNATIONAL_BOND_COLUMNS,
        ISHARES_REAL_RETURN_BOND_COLUMNS
        # VANGUARD_CA_EQUITY_HEADER,
        # VANGUARD_CA_BOND_HEADER
    ]

    def readlines(file_path)
        raise "File not found" if !File.exist?(file_path)

        contents = File.readlines(file_path)
        contents = drop_etf_info(contents)
        drop_bundled_etf_info(contents)
    end

    private
    def drop_etf_info(contents)
        header_index = contents.find_index {|line|
            HEADERS.find {|header|
                line.start_with?(header)
            }
        }

        raise "Column headers not found." unless header_index
        contents.drop(header_index)
    end

    def drop_bundled_etf_info(contents)
        contents.take_while {|line|
            "" != line.gsub(/[[:space:]]/, "")
        }
    end
end
