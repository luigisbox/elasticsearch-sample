# Elasticsearch queries and example application

- Find the example queries in [EXAMPLES.md](EXAMPLES.md)
- For Slovak language support, see:
  - https://github.com/essential-data/elasticsearch-sk
  - https://github.com/SlovakNationalGallery/elasticsearch-slovencina

# Simple search using Elasticsearch

To run this application, you'll need 

- [PostgreSQL database](https://www.postgresql.org/download/)
- [Elasticsearch](https://www.elastic.co/downloads/elasticsearch)

Either install them locally, or, if you know what you are doing, use docker images. I used following containers during the live demo.

    docker run -p 5432:5432 -v ~/viir-pg-data:/var/lib/postgresql/data postgres:9.6
    docker run -p 9200:9200 elasticsearch:5.5

You will also need a working Ruby installation.

## Importing data to PostgreSQL

Download the dataset from https://ekosystem.slovensko.digital/otvorene-data#crz and decompress it. 
You can import the data into PostgreSQL with this command

    psql -h localhost -U postgres crz < crz.sql
    
Make sure the database called `crz` exists, before you try to import the dump. You can create it by running `create database crz` as the `postgres` user.

Importing the data will take some time.

## Importing data from PostgreSQL to Elasticsearch

Check the config file in `config/database.yml` and update DB connection parameters if needed. Then run 

    bundle exec rake import:mapping
    bundle exec rake import:dump
    
The import will again take a long time, but you can work with the data while it is importing.

## Running the application

Install dependencies with

    bundle
    
You may need to install PostgreSQL development headers (package `libpq-dev` on Linux) first.

Then run the application with

    rails s
    
The application should be running on http://localhost:3000/search

![Screenshot](demo.png)

## Crossroads

- The import from PostgreSQL to Elasticsearch is in `lib/tasks/import.rake`
- Elasticsearch query is in `app/controllers/searches_controller.rb`
- HTML frontend in `app/views/searches/show.html.erb`
