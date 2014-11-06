rm db/*.sqlite3
rm db/schema.rb
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

