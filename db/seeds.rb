# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require "open-uri"

VN_UNITS_SQL_URL = "https://raw.githubusercontent.com/thanglequoc/vietnamese-provinces-database/master/postgresql/postgres_ImportData_vn_units.sql"

if AdministrativeRegion.any?
  puts "Vietnamese provinces data already seeded. Skipping."
else
  puts "Downloading Vietnamese provinces data from GitHub..."
  sql = URI.open(VN_UNITS_SQL_URL).read
  puts "Executing seed SQL (this may take a moment)..."
  ActiveRecord::Base.connection.execute(sql)
  puts "Done. Seeded:"
  puts "  #{AdministrativeRegion.count} administrative regions"
  puts "  #{AdministrativeUnit.count} administrative units"
  puts "  #{Province.count} provinces"
  puts "  #{Ward.count} wards"
end
