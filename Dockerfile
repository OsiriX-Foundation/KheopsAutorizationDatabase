FROM postgres:latest

ADD create-psql.sql docker-entrypoint-initdb.d
