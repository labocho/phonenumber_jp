# encoding: UTF-8
require "nokogiri"
require "open-uri"
require "uri"
require "tempfile"
require "spreadsheet"
require "csv"
require "date"

include FileUtils

INDEX_URL = "http://www.soumu.go.jp/main_sosiki/joho_tsusin/top/tel_number/number_shitei.html"
EXCEL_FILE_URLS = %w(
  http://www.soumu.go.jp/main_content/000124070.xls
  http://www.soumu.go.jp/main_content/000124071.xls
  http://www.soumu.go.jp/main_content/000124072.xls
  http://www.soumu.go.jp/main_content/000124073.xls
  http://www.soumu.go.jp/main_content/000124074.xls
  http://www.soumu.go.jp/main_content/000124075.xls
  http://www.soumu.go.jp/main_content/000124076.xls
  http://www.soumu.go.jp/main_content/000124077.xls
  http://www.soumu.go.jp/main_content/000124078.xls
)
HEADERS = %w(
  番号区画コード
  MA
  番号
  市外局番
  市内局番
  指定事業者
  使用状況
  備考
)
DATA_DIR = "#{__dir__}/../tmp/data"
CSV_FILENAME = "combined.csv"
REVISION_FILENAME = "REVISION"

def parse_revision(string)
  string = string.strip
  unless string =~ /\A\(平成(\d+)年(\d+)月(\d+)日現在\)\z/
    STDERR.puts "Invalid upated_at: #{string}"
    exit 1
  end
  heisei_y, m, d = $~.captures.map(&:to_i)
  y = heisei_y + 1988
  Date.new(y, m, d)
end

# Checking whether linked from index
index = Nokogiri.parse open(INDEX_URL){|f| f.read }
urls = index.css("a[href]").map{|e| URI.join(INDEX_URL, e["href"]).to_s }
unlinked = EXCEL_FILE_URLS - urls
unless unlinked.empty?
  unlinked.each{|url| STDERR.puts "#{url} is not linked from index" }
  exit 1
end

csv = CSV.open(File.join(DATA_DIR, CSV_FILENAME), "w")
csv << HEADERS
revision = nil

# Download xls
EXCEL_FILE_URLS.each{|url|
  # Download xls
  xls = Tempfile.new("phonenumber")
  STDERR.puts "Download #{url}"
  open(url){|src| xls.write(src.read) }
  xls.close
  # Read xls
  book = Spreadsheet.open(xls.path)
  sheet = book.worksheet(0)
  STDERR.puts "Convert #{url}"
  sheet.rows.each_with_index do |row, index|
    case index
    when 0
      current_revision = parse_revision row.to_a.reject{|cell| cell.nil? || cell.strip == "" }.first
      revision ||= current_revision
      unless revision == current_revision
        STDERR.puts "revision unmatched: #{revision} #{current_revision}"
        exit 1
      end
    when 1
      unless row.to_a == HEADERS
        STDERR.puts "Unexpected header: #{row.to_a.inspect}"
        exit 1
      end
    else
      csv << row.to_a
    end
  end
}

File.write(File.join(DATA_DIR, REVISION_FILENAME), revision.iso8601 + "\n")
