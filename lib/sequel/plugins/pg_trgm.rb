module Sequel
  module Plugins
    module PgTrgm
      module DatasetMethods
        def text_search(column, query)
          where("#{column} % #{Sequel::Model.db.literal query}").order_by{ Sequel.desc(similarity(column, query)) }
        end
      end
    end
  end
end
