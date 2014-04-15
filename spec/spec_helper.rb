require 'rubygems'
require 'bundler'
require 'sequel'
require 'logger'

unless defined?(DB)
  DB = Sequel.connect('postgres://localhost/pg-trgm-test')
  DB.loggers << Logger.new($stdout)
end

