require 'rubygems'
require 'bundler/setup'
require 'dm-aggregates'
require 'dm-core'
require 'dm-migrations'
require 'dm-types'
require 'open-uri'
require 'date'

DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_ROSE_URL'] || 'postgres://localhost/tom_wotd')

class Word
  include DataMapper::Resource

  property :id, Serial
  property :word, String
  property :definition, Text

  property :delivery_order, Integer

end

class User
  include DataMapper::Resource
  property :id, Serial

  property :username, String
  property :password, String
end



DataMapper.finalize
