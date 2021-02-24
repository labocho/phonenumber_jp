require "bundler/gem_tasks"
task :default => :spec

directory "tmp"
directory "tmp/xls" => "tmp"
directory "tmp/csv" => "tmp"

file "tmp/xls2csv.jar" do
  require "open-uri"
  warn "Download xls2csv.jar"
  File.write(
    "tmp/xls2csv.jar",
    open("https://github.com/labocho/xls2csv/releases/download/v0.1.1/xls2csv.jar", &:read),
  )
end

namespace "area_codes" do
  task "xls" => "tmp/xls" do
    next unless Dir.glob("tmp/xls/*").empty?

    ruby "scripts/xls_downloader.rb"
  end

  task "csv" => ["xls", "tmp/csv", "tmp/xls2csv.jar"] do
    next unless Dir.glob("tmp/csv/*").empty?

    ruby "scripts/convert_xls_to_csv.rb"
  end

  task "clean" do
    rm_rf "tmp"
  end

  task "update" => "csv" do
    ruby "scripts/update_area_codes_list.rb"
  end
end

namespace "steep" do
  task "check" do
    sh "steep check"
  end
end
