require "open-uri"

namespace :vn_units do
  desc "Seed Vietnamese administrative units (regions, provinces, wards) from upstream source"
  task seed: :environment do
    url = "https://raw.githubusercontent.com/thanglequoc/vietnamese-provinces-database/master/postgresql/postgres_ImportData_vn_units.sql"

    if AdministrativeRegion.any?
      puts "Vietnamese provinces data already present (#{AdministrativeRegion.count} regions, #{Province.count} provinces, #{Ward.count} wards)."
      puts "To re-seed, truncate the tables first: rails vn_units:truncate"
      next
    end

    puts "Downloading Vietnamese provinces data..."
    sql = URI.open(url).read
    puts "Executing SQL..."
    ActiveRecord::Base.connection.execute(sql)
    puts "Seeded successfully:"
    puts "  #{AdministrativeRegion.count} administrative regions"
    puts "  #{AdministrativeUnit.count} administrative units"
    puts "  #{Province.count} provinces"
    puts "  #{Ward.count} wards"
  end

  desc "Truncate all Vietnamese administrative unit tables (DESTRUCTIVE)"
  task truncate: :environment do
    puts "Truncating vn_units tables..."
    ActiveRecord::Base.connection.execute("TRUNCATE wards, provinces, administrative_units, administrative_regions RESTART IDENTITY CASCADE")
    puts "Done."
  end
end
