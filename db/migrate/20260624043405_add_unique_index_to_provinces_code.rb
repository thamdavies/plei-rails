class AddUniqueIndexToProvincesCode < ActiveRecord::Migration[8.1]
  # This migration is a no-op: the unique index on provinces.code was moved into
  # CreateProvinces (20260624043210). It exists only so existing databases that
  # ran this as a separate migration step remain consistent.
  def change
  end
end
