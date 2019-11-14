require "phonenumber_jp/version"

module PhonenumberJp
  AREA_CODES = File.read("#{File.dirname(__FILE__)}/phonenumber_jp/area_codes_for_matching.csv").split("\n")

  class << self
    def hyphenate(phonenumber)
      return unless phonenumber
      phonenumber = phonenumber.gsub(/[^0-9\+]/, "")
      case phonenumber
      when nil
      when /^\+81/
        "+81-" + hyphenate("0" + phonenumber[3..-1])[1..-1]
      when /^(050)(\d\d\d\d)(\d\d\d\d)$/, # IP 電話
           /^(0800)(\d\d\d)(\d\d\d\d)$/, # フリーダイヤル
           /^(0[789]0)(\d\d\d\d)(\d\d\d\d)$/, # 携帯電話・PHS
           /^(020)(\d\d\d\d)(\d\d\d\d)$/, # ポケベル
           /^(0120)(\d\d\d)(\d\d\d)$/, # フリーダイヤル
           /^(0570)(\d\d\d)(\d\d\d)$/, # ナビダイヤル
           /^(0990)(\d\d\d)(\d\d\d)$/ # ダイヤル Q2
        $~.captures.join("-")
      when /^0(\d{9})$/ # 固定電話
        return phonenumber unless area_code = find_area_code(phonenumber)
        l = area_code.length
        [ phonenumber[0..(l - 1)],
          phonenumber[l..5],
          phonenumber[6..-1]
        ].join("-")
      else
        phonenumber
      end
    end

    private
    def find_area_code(phonenumber)
      AREA_CODES.find{|area_code|
        phonenumber[0..(area_code.length - 1)] == area_code
      }
    end
  end
end
