describe PhonenumberJp do
  describe "VERSION" do
    subject { PhonenumberJp::VERSION }
    it { should be_a String }
  end

  describe ".hyphenate" do
    subject { PhonenumberJp.hyphenate(val) }

    context "nil" do
      let(:val) { nil }
      it { should eq nil }
    end

    context "IP phone" do
      let(:val) { "05012345678" }
      it { should eq "050-1234-5678" }
    end

    context "Free dial (0800)" do
      let(:val) { "08001234567" }
      it { should eq "0800-123-4567" }
    end

    context "Cellular phone" do
      let(:val) { "08012345678" }
      it { should eq "080-1234-5678" }
    end

    context "14 digit data transfer number" do
      let(:val) { "02001234567890" }
      it { should eq "0200-12345-67890" }
    end

    context "Pocket bell" do
      let(:val) { "02042345678" }
      it { should eq "020-423-45678" }
    end

    context "Free dial (0120)" do
      let(:val) { "0120123456" }
      it { should eq "0120-123-456" }
    end

    context "Navi dial" do
      let(:val) { "0570123456" }
      it { should eq "0570-123-456" }
    end

    context "Dial Q2" do
      let(:val) { "0990123456" }
      it { should eq "0990-123-456" }
    end

    context "Area code 0594" do
      let(:val) { "0594123456" }
      it { should eq "0594-12-3456" }
    end

    context "Area code 059" do
      let(:val) { "0592123456" }
      it { should eq "059-212-3456" }
    end

    context "+81" do
      let(:val) { "+81594123456" }
      it { should eq "+81-594-12-3456" }
    end

    context "not match" do
      let(:val) { "9999999999" }
      it { should eq "9999999999" }
    end
  end

  describe "e164" do
    subject { PhonenumberJp.e164(val, delimiter: " ") }
    context "+81" do
      let(:val) { "+81594123456" }
      it { should eq "+81 594 12 3456" }
    end

    context "Cellular phone" do
      let(:val) { "08012345678" }
      it { should eq "+81 80 1234 5678" }
    end

    context "not match" do
      let(:val) { "9999999999" }
      it { should eq "9999999999" }
    end
  end

  describe "local" do
    subject { PhonenumberJp.local(val, delimiter: " ") }
    context "+81" do
      let(:val) { "+81594123456" }
      it { should eq "0594 12 3456" }
    end

    context "Cellular phone" do
      let(:val) { "08012345678" }
      it { should eq "080 1234 5678" }
    end

    context "not match" do
      let(:val) { "9999999999" }
      it { should eq "9999999999" }
    end
  end

  describe "valid?" do
    subject { PhonenumberJp.valid?(val) }

    context "Area code 059" do
      let(:val) { "0592123456" }
      it { should eq true }
    end

    context "+81" do
      let(:val) { "+81594123456" }
      it { should eq true }
    end

    context "not match" do
      let(:val) { "9999999999" }
      it { should eq false }
    end

    context "invalid local" do
      let(:val) { "+81000000000" }
      it { should eq false }
    end
  end
end
