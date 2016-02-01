class ETF::Scrape::Vanguard::US::CSVSanitizer

    # EQUITY_COLUMNS = ",SEDOL,Ticker,Holding name,Shares,Market value,% of fund*,Sector,Country,Security depository receipt type,"
    # BOND_COLUMNS = ",SEDOL,Holding name,Coupon/Yield,Maturity date,Face amount,Market value,% of fund*,"
    # RESERVE_HOLDINGS_COLUMNS = ",SEDOL,Holding name,Maturity date,Face amount,% of fund*,"

    def readlines(file_path)
        raise "File not found" if !File.exist?(file_path)

        contents = File.readlines(file_path)
        contents = drop_etf_info(contents)
        contents = drop_etf_notes(contents)
        contents = strip_excelisms(contents)

        bond_start_index = contents.find_index {|line| line.strip == "Bond holdings" }
        reserve_holdings_index = contents.find_index {|line| line.strip == "Short-term reserve holdings" }

        raise "Bonds header not found in #{file_path}." if bond_start_index == nil
        raise "Reserve holdings header not found in #{file_path}." if reserve_holdings_index == nil

        [
            contents[0...bond_start_index],
            contents[(bond_start_index+1)...reserve_holdings_index],
            contents[(reserve_holdings_index+1)..contents.length]
        ]
    end

    def drop_etf_info(contents)
        header_index = contents.find_index {|line| line.strip == "Stock holdings" } + 1

        raise "Equity headers not found." unless header_index
        contents.drop(header_index)
    end

    # Removes "Percentages may not add up to 100%" disclaimer",
    # and "For more information on Vanguard funds" text.
    def drop_etf_notes(contents)
        contents.take_while {|line|
            "" != line.gsub(/[[:space:]]/, "")
        }
    end

    def strip_excelisms(contents)
        contents.map {|line|
            line.sub(/,=(".*?",)/, ",\\1")
        }
    end
end
