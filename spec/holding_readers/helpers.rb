def assert_equity_fields(asset, expected_values)
    expected_values.each {|key, value|
        # p "#{key} - #{value} - #{asset.send(key)}"
        actual_value = asset.send(key)
        expect(actual_value).to eq(value), "Unexpected value for '#{key}'\n   expected: '#{value}'\n        got: '#{actual_value}'"
    }
end

def assert_bond_fields(asset, expected_values)
    assert_equity_fields(asset, expected_values)
end
