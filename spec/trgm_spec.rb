require 'spec_helper.rb'
Sequel.extension(:migration)

describe 'pg_trgm' do
  before(:each) do
    DB.create_table(:foods) do |t|
      primary_key :id
      String :name
    end
  end

  after(:each) do
    DB.drop_table(:foods)
    DB.drop_table(:schema_info)
  end

  describe 'add_pg_trgm' do
    before do
      Sequel::Migrator.apply(DB, 'spec/files', 1)
    end

    it 'creates trgm index' do
      expect(DB[:pg_class].where(relname: 'foods_name_trgm_index').count).to eq 1
    end

    it 'has trgm limit' do
      expect(DB['SELECT show_limit();'].first[:show_limit]).to be_kind_of(Float)
    end
  end

  describe 'drop_pg_trgm' do
    before do
      Sequel::Migrator.apply(DB, 'spec/files', 1)
    end

    it 'drops trgm index' do
      expect(DB[:pg_class].where(relname: 'foods_name_trgm_index').count).to eq 1
      Sequel::Migrator.apply(DB, 'spec/files', 0)
      expect(DB[:pg_class].where(relname: 'foods_name_trgm_index').count).to eq 0
    end
  end

  describe 'text_search' do
    before do
      Sequel::Migrator.apply(DB, 'spec/files', 1)

      class Food < Sequel::Model(DB)
        plugin :pg_trgm
      end

      Food.create(name: 'Banana Pancakes')
    end

    it 'returns proper search results' do
      expect(Food.dataset.text_search(:name, 'Banan cakes').count).to eq 1
    end
  end
end
