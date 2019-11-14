require "csv"
require "set"

numbers = Set.new

Dir.glob("#{__dir__}/../tmp/csv/*.csv").each do |path|
  open(path) do |f|
    f.gets # skip first line
    csv = CSV.new(f, headers: :first_row)
    csv.each do |row|
      next unless num = row["市外局番"]
      numbers << num
    end
  end
end

output = numbers.sort_by{|n| [-n.length, n] }.join("\n") + "\n"

File.write("#{__dir__}/../lib/phonenumber_jp/area_codes_for_matching.csv", output)
