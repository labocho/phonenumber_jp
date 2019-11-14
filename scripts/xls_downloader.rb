require "open-uri"
require "uri"
require "nokogiri"

URL = URI("http://www.soumu.go.jp/main_sosiki/joho_tsusin/top/tel_number/number_shitei.html")

html = open(URL.to_s, &:read)
doc = Nokogiri.parse(html)
xls_urls = []

doc.css("h3").find{|h3| h3.text.include?("固定電話の電話番号") }.parent.css("a").each do |a|
  next unless a["href"] =~ /\.xls/
  xls_urls << (URL + a["href"]).to_s
end

xls_urls.each do |url|
  basename = url.gsub(%r(.*/), "")
  dest = "#{__dir__}/../tmp/xls/#{basename}"
  $stderr.puts "Download #{url} to #{dest}"
  File.write(dest, open(url, &:read))
end
