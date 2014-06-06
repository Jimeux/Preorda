# README #

If ye have a default Postgres DB user with superuser privileges, the DB should create alright. If you have to create a new user, just call it launchbro and add the username field for the development piece in `config/database.yml`.

Try running the grazer with `bundle exec rake graze:amazon_games`. Sometimes the image ends up as some base-64 string piece and it funks up. I think running `spring stop` sorts it out, since that seems to be caching something somehow. 

Spring is some prelauncher piece that makes Rails commands faster, especially tests. It seems to get started up with the server.

Check out `db/schema.rb` for an overview of the current schema. 

Feel free to make views for the Department/Items controllers and experiment with scopes in the models. 