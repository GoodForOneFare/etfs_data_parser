require_relative "../../../holding_readers/index"

RSpec.describe ETF::Scrape::Vanguard::US::CSVSanitizer do
    let(:reader) { ETF::Scrape::Vanguard::US::CSVSanitizer.new }
    let(:blocks) { reader.readlines("spec/holding_readers/vanguard_us/with_mixed_holdings.csv") }

    it "raises error if CSV file does not exist" do
        expect {
            reader.readlines("unknown_file.csv")
        }.to raise_error(/File not found/)
    end

    it "finds equities block" do
        lines = blocks[0]

        expect(lines.length).to eq(3)

        expect(lines[0].strip).to match(/^,SEDOL,Ticker,Holding name,Shares,Market value,% of fund\*,Sector,Country,Security depository receipt type,$/)
        expect(lines[1].strip).to match(/^,"SEDOL_1","EQUITY_1  ","NAME_1","11,111,111","\$11,111,111\.10","1\.11111","SECTOR_1","COUNTRY_1  ",SDRT_1,$/)
        expect(lines[2].strip).to match(/^,"SEDOL_2","EQUITY_2  ","NAME_2","22,222,222","\$22,222,222\.20","2\.22222","SECTOR_2","COUNTRY_2  ",SDRT_2,$/)
    end

    it "finds bonds block" do
        lines = blocks[1]

        expect(lines.length).to eq(2)
        expect(lines[0].strip).to match(/^,SEDOL,Holding name,Coupon\/Yield,Maturity date,Face amount,Market value,% of fund\*,$/)
        expect(lines[1].strip).to match(/^,"SEDOL1","BOND_1     ","3\.33333","03\/04\/2015","\$3,333,333\.36","\$3,333,333\.37","3\.33338",$/)
    end

    it "finds short term holdings block" do
        lines = blocks[2]

        expect(lines.length).to eq(2)
        expect(lines[0]).to match(/^,SEDOL,Holding name,Maturity date,Face amount,% of fund\*,$/)
        expect(lines[1]).to match(/^,-,"RESERVE_1",-,"\$44,444,444\.41","4\.44442",$/)
    end

    it "finds no other blocks" do
        expect(blocks.length).to eq(3)
    end
end
