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

      phonenumber = phonenumber.gsub(/[^0-9+]/, "")
      return [] if phonenumber.length == 0

      case phonenumber
      when /^\+81/
        local = split("0" + phonenumber[3..-1].to_s) # steep does not know that `phonenumber[3..-1]` will be return String always. Call `to_s` to tell it is String.
        return [phonenumber] if local.length < 2

        local[0] = local[0][1..-1].to_s # steep does not know that `local[0][1..-1]` will be return String always. Call `to_s` to tell it is String.
        ["+81"] + local
      when /^(0120)(\d\d\d)(\d\d\d)$/, # 着信課金機能 (フリーダイヤル)
          /^(0800)(\d\d\d)(\d\d\d\d)$/, # 着信課金機能(フリーダイヤル)
          /^(0180)(\d\d\d)(\d\d\d)$/, # 大量呼受付機能
          /^(0570)(\d\d\d)(\d\d\d)$/, # ナビダイヤル
          /^(0990)(\d\d\d)(\d\d\d)$/, # ダイヤル Q2
          /^(020)(\d\d\d)(\d\d\d\d\d)$/, # データ伝送携帯電話番号, 無線呼出番号
          /^(0200)(\d\d\d\d\d)(\d\d\d\d\d)$/, # データ伝送携帯電話番号
          /^(0[789]0)(\d\d\d\d)(\d\d\d\d)$/, # 携帯電話・PHS
          /^(050)(\d\d\d\d)(\d\d\d\d)$/ # IP 電話
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
