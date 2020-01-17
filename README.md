sequel-pg-trgm
==============

Sequel plugin for Postgres' [pg_trgm](http://www.postgresql.org/docs/9.1/static/pgtrgm.html).

## Installation

```ruby
gem install sequel-pg-trgm
```

Install the pg_trgm extension in Postgres:
```bash
psql
> CREATE EXTENSION pg_trgm;
```


## Usage
sequel-pg-trgm creates a dataset method and a helper for creating an index in migrations.

To create the index column for searching, create a new migration like the following:

```ruby
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
```

```ruby
class Food < Sequel::Model
  plugin :pg_trgm
end
```

### Querying
If you have an application that lets a user search for foods, the query to search the name column on the `Food` model would be:

```ruby
Food.dataset.text_search(:name, 'Banana Pancakes')
```

## Notes:
Will only work for Postgres databases.  Right now, all results are ordered by their similarity to the query.

### pg_trgm search threshold
Postgres' pg_trgm has a default threshold of 0.3, and will not return results if any results do not match at least that percentage.

#### Example:

If you are trying to get the Food with name 'Banana Pancakes', you may expect to get that back when searching 'ba' or 'ban', but you will not.

```ruby
Food.dataset.text_search(:name, 'ba').first
# => nil
Food.dataset.text_search(:name, 'ban').first
# => nil
Food.dataset.text_search(:name, 'bana').first
# => <Food @values={:id=>12, :name=>"Banana Pancakes"}>
```

However, if you set the limit to be lower, say 0.1, you will get results for less accurate searches.  It seems to get set per connection, so just calling ``select set_limit(0.1);`` once after connecting won't guarantee the value is always going to be set. Calling it in Sequel's after_connect hook usually solves this.

```ruby
after_connect = proc do |connection|
  begin
    connection.query("select set_limit(0.1);")
  rescue PG::UndefinedFunction
  end
end
Sequel.connect("postgres://localhost/foods", :loggers => [logger], after_connect: after_connect)
```
