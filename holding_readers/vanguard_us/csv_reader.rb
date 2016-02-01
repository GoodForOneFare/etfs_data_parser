require "csv"

class ETF::Scrape::Vanguard::US::CSVReader
    def readlines(file_path)
        blocks = ETF::Scrape::Vanguard::US::CSVSanitizer.new.readlines(file_path)

        [
            get_assets(blocks[0], ETF::EquityAsset.instance_method(:from_vanguard_us)),
            get_assets(blocks[1], ETF::BondAsset.instance_method(:from_vanguard_us))
            # TODO: add reserve holdings.
        ]
    end

    private
    def get_assets(lines, asset_initializer_method)
        lines.shift # Remove the columns line.

        tempfile = Tempfile.new("vanguard_us_csv")
        lines.each {|line|
            tempfile.write(line)
        }
        tempfile.close

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
end