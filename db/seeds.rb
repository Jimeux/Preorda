# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


names = %w{ Amazon iTunes }
names.each { |name| Store.create(name: name) }

names = %w{ Games DVD Blu-Ray Music }
names.each { |name| Department.create(name: name) }