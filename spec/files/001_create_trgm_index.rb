Sequel.migration do
  up do
    extension :pg_trgm
    add_pg_trgm(:foods, :name)
  end

  down do
    extension :pg_trgm
    drop_pg_trgm(:foods, :name)
  end
end

