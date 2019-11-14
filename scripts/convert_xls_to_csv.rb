require "open3"
Dir.glob("#{__dir__}/../tmp/xls/*").each do |xls|
  dest = "#{__dir__}/../tmp/csv/#{File.basename(xls).gsub(/\.xls$/, ".csv")}"

  $stderr.puts "Convert #{xls} to #{dest}"
  o, e, s = Open3.capture3("java", "-jar", "#{__dir__}/../tmp/xls2csv.jar", stdin_data: File.read(xls, encoding: "ascii-8bit"))

  unless s.success?
    $stderr.puts e
    exit s.to_i
  end

  File.write(dest, o)
end
