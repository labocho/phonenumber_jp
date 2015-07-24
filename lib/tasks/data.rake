namespace :data do
  task :generate => ["data/area_codes_for_matching.csv", "data/REVISION"]

  task :clean do
    rm_rf "data"
    rm_rf "tmp/data"
  end

  task :update => [:clean, :generate]

  directory "tmp/data"

  file "tmp/data/combined.csv" => "tmp/data" do
    ruby "scripts/update.rb"
  end

  file "tmp/data/normalized.csv" => "tmp/data/combined.csv" do
    require "charwidth"
    open("tmp/data/normalized.csv", "w"){|f|
      combined = File.read("tmp/data/combined.csv")
      f.write(Charwidth.normalize(combined))
    }
  end

  file "tmp/data/area_codes.csv" => "tmp/data/normalized.csv" do
    require "csv"
    area_codes = {}
    CSV.foreach("tmp/data/normalized.csv", headers: :first_row) do |row|
      area_codes[row["市外局番"].strip] = 1
    end
    File.write("tmp/data/area_codes.csv", area_codes.keys.sort.join("\n"))
  end

  file "data/area_codes_for_matching.csv" => ["tmp/data/area_codes.csv"] do
    area_codes = File.read("tmp/data/area_codes.csv").split("\n")
    area_codes.sort_by!{|line| [-line.length, line] }
    mkdir_p "data"
    File.write("data/area_codes_for_matching.csv", area_codes.join("\n"))
  end

  file "data/REVISION" => ["tmp/data/combined.csv"] do
    cp "tmp/data/REVISION", "data/REVISION"
  end
end

task "data" => "data:update"
