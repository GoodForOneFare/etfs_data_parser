require "csv"

class ETF::Scrape::IShares::CSVReader
    def readlines(file_path)
        lines = ETF::Scrape::IShares::CSVSanitizer.new.readlines(file_path)

        header = lines.shift


        tempfile = Tempfile.new("temp_ishares_csv")
        lines.each {|line|
            tempfile.write(line)
        }
        tempfile.close

        asset_initializer_method = get_asset_type(header)
        asset_class = asset_initializer_method.owner

        CSV.open(tempfile, headers: false, header_converters: [:symbol, :downcase]).readlines.map {|line|
            begin
                asset = asset_class.new
                asset.send(asset_initializer_method.name, line)
                asset
            rescue Exception => e
                p "Error reading line #{line.join(",")}\n#{e}."
                raise e
            end
        }

    end

    private
    HEADER_TO_ASSET_TYPE_MAP = {
        "#{ETF::Scrape::IShares::CSVSanitizer::ISHARES_EQUITY_COLUMNS}" => ETF::EquityAsset.instance_method(:from_ishares),
        "#{ETF::Scrape::IShares::CSVSanitizer::ISHARES_BOND_COLUMNS}"   => ETF::BondAsset.instance_method(:from_ishares),
        "#{ETF::Scrape::IShares::CSVSanitizer::ISHARES_INTERNATIONAL_BOND_COLUMNS}" => ETF::InternationalBondAsset.instance_method(:from_ishares),
        "#{ETF::Scrape::IShares::CSVSanitizer::ISHARES_REAL_RETURN_BOND_COLUMNS}" => ETF::RealReturnBondAsset.instance_method(:from_ishares)
    }

    def get_asset_type(header)
        HEADER_TO_ASSET_TYPE_MAP[header.strip] or raise "Unknown ishares header type: '#{header}'."
    end
end