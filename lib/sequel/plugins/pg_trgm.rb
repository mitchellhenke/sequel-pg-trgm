module Sequel
  module Plugins
    module PgTrgm
      module DatasetMethods
        def text_search(column, query)
          where("? % ?", column, query).reverse_order{ similarity(column, query) }
        end
      end
    end
  end
end
