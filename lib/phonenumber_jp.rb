require "phonenumber_jp/version"

module PhonenumberJp
  AREA_CODES = File.read("#{__dir__}/phonenumber_jp/area_codes_for_matching.csv").strip.split("\n").map(&:freeze).freeze

  class << self
    # @param phonenumber [String, nil]
    # @return [String, nil]
    def hyphenate(phonenumber)
      parts = split(phonenumber)
      return nil if parts.empty?

      parts.join("-")
    end

    # @param phonenumber [String, nil]
    # @return [true, false]
    def valid?(phonenumber)
      split(phonenumber).length > 1
    end

    private
    # @param phonenumber [String, nil]
    # @return [Array[String]]
    def split(phonenumber)
      return [] if phonenumber.nil?

      phonenumber = phonenumber.gsub(/[^0-9\+]/, "")
      return [] if phonenumber.length == 0

      case phonenumber
      when /^\+81/
        local = split("0" + phonenumber[3..-1])
        return [phonenumber] if local.length < 2

        local[0] = local[0][1..-1]
        ["+81"] + local
      when /^(050)(\d\d\d\d)(\d\d\d\d)$/, # IP 電話
          /^(0800)(\d\d\d)(\d\d\d\d)$/, # フリーダイヤル
          /^(0[789]0)(\d\d\d\d)(\d\d\d\d)$/, # 携帯電話・PHS
          /^(020)(\d\d\d\d)(\d\d\d\d)$/, # ポケベル
          /^(0120)(\d\d\d)(\d\d\d)$/, # フリーダイヤル
          /^(0570)(\d\d\d)(\d\d\d)$/, # ナビダイヤル
          /^(0990)(\d\d\d)(\d\d\d)$/ # ダイヤル Q2
        $~.captures
      when /^0(\d{9})$/ # 固定電話
        return [phonenumber] unless (area_code = find_area_code(phonenumber))

        l = area_code.length
        [
          phonenumber[0..(l - 1)],
          phonenumber[l..5],
          phonenumber[6..-1],
        ]
      else
        [phonenumber]
      end
    end

    # @param phonenumber [String]
    # @return [String, nil]
    def find_area_code(phonenumber)
      AREA_CODES.find {|area_code|
        phonenumber[0..(area_code.length - 1)] == area_code
      }
    end
  end
end
