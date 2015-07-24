require "phonenumber_jp/version"

module PhonenumberJp
  AREA_CODES = File.read("#{__dir__}/../data/area_codes_for_matching.csv").split("\n")
  UPDATED = Date.new(*(File.read("#{__dir__}/../data/REVISION").strip.split("-").map(&:to_i)))

  module_function
  def hyphenate(phonenumber)
    return unless phonenumber
    phonenumber = phonenumber.gsub(/[^0-9\+]/, "")
    case phonenumber
    when nil
    when /^\+81/
      "+81-" + hyphenate("0" + phonenumber[3..-1])[1..-1]
    when /^(050)(\d\d\d\d)(\d\d\d\d)$/, # IP phone
         /^(0[789]0)(\d\d\d\d)(\d\d\d\d)$/, # Mobile/PHS
         /^(020)(\d\d\d\d)(\d\d\d\d)$/, # Pocket bell
         /^(0120)(\d\d\d)(\d\d\d)/, # Free dial
         /^(0800)(\d\d\d)(\d\d\d\d)/, # Free dial
         /^(0570)(\d\d\d)(\d\d\d)/, # Navi dial
         /^(0990)(\d\d\d)(\d\d\d)/ # Dial Q2
      $~.captures.join("-")
    when /^0(\d{9})$/ # Land-line
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

  def find_area_code(phonenumber)
    length = nil
    part = nil
    AREA_CODES.find{|area_code|
      unless length == area_code.length
        length = area_code.length
        part = phonenumber[0..(length - 1)]
      end
      part == area_code
    }
  end

  def updated
    UPDATED
  end
end
