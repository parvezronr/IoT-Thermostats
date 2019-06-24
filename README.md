IOT Thermostats

Make sure you have Ruby version - 2.5.1

Make sure you have Rails version > = 5.2.0

Make sure you have PostgreSQL installed in your maching >= 9.3 (suggested 9.4.5)

Make sure redis is installed (suggested - 3.0.6)


Follow the steps to setup this project on your local:

* Clone/Download this project.
* Run `bundle install` or `bundle install --local` command to install all the gems in *vendor/bundle* folder.
* Copy all `*.yml.sample` files in *config* folder and rename them as `*.yml` in the same folder.
* Rename Procfile.sample to Procfile and make sure to add desired configurations.
* Create, migrate and seed the database.
* Run `rake swagger:docs` command to generate the API Documentation.
* Start the server using `foreman start` and hit the home page using `localhost:3000` which is default.
* Make sure when swagger index page comes it has proper api-docs.json path (By default).

* Run tests using `bundle exec rspec` and make sure everything is green.