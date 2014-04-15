module Sequel
  module Postgres
    module PgTrgm
      def add_pg_trgm(table, column, op={})
        self.run "CREATE INDEX #{table}_#{column}_trgm_index ON #{table} USING gist (#{column} gist_trgm_ops);"
      end

      def drop_pg_trgm(table, column)
        self.run "DROP INDEX #{table}_#{column}_trgm_index;"
      end
    end
  end

  Database.register_extension(:pg_trgm, Postgres::PgTrgm)
end
