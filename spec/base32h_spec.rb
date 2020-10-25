RSpec.describe Base32H do
  context "when using the module directly" do
    context "to encode digits" do
      CSV.foreach('./spec/cases/digit-encode.csv', headers: true) do |r|
        from = r['decimal'].to_i
        to = r['base32h']

        it "encodes #{from} to #{to}" do
          expect(Base32H.encode from).to eq to
        end
      end
    end

    context "to decode digits" do
      CSV.foreach('./spec/cases/digit-decode.csv', headers: true) do |r|
        from = r['base32h']
        to = r['decimal'].to_i

        it "decodes #{from} to #{to}" do
          expect(Base32H.decode from).to eq to
        end
      end
    end

    context "to encode numbers" do
      CSV.foreach('./spec/cases/numeric-encode.csv', headers: true) do |r|
        from = r['decimal'].to_i
        to = r['base32h']

        it "encodes #{from} to #{to}" do
          expect(Base32H.encode from).to eq to
        end
      end
    end

    context "to decode numbers" do
      CSV.foreach('./spec/cases/numeric-decode.csv', headers: true) do |r|
        from = r['base32h']
        to = r['decimal'].to_i

        it "decodes #{from} to #{to}" do
          expect(Base32H.decode from).to eq to
        end
      end
    end

    context "to encode binary data" do
      CSV.foreach('./spec/cases/binary-encode.csv', headers: true) do |r|
        from = r['bytes'].split('.').map {|b| b.to_i}
        from_packed = from.pack('C*')
        to = r['base32h']

        it "encodes #{from} (packed bytes) to #{to}" do
          expect(Base32H.encode_bin from_packed).to eq to
        end
      end
    end

    context "to decode binary data" do
      CSV.foreach('./spec/cases/binary-decode.csv', headers: true) do |r|
        from = r['base32h']
        to = r['bytes'].split('.').map {|b| b.to_i}
        to_packed = to.pack('C*')

        it "decodes #{from} to #{to} (packed bytes)" do
          expect(Base32H.decode_bin from).to eq to_packed
        end
      end
    end
  end
end
