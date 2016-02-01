class ETF::Scrape::Vanguard::CA::BondCSVSanitizer

    BOND_HEADER = "Securities,Rate,Maturity date,% of assets*"

    def readlines(file_path)
        raise "File not found" if !File.exist?(file_path)

        contents = File.readlines(file_path)
        contents = drop_headers(contents)
        drop_wrapper_etf_disclaimer(contents)
    end

    private
    def drop_headers(contents)
        header_index = contents.find_index {|line|
            line.start_with?(BOND_HEADER)
        }

        contents.drop(header_index+1)
    end

    def drop_wrapper_etf_disclaimer(contents)
        contents.take_while {|line|
            "" != line.gsub(/[[:space:]]/, "")
        }
    end
end
