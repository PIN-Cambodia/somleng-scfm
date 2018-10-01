FROM ruby:latest

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libnss3 libgconf-2-4

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/Gemfile
ADD Gemfile.lock /usr/src/app/Gemfile.lock
RUN bundle install
ADD . /usr/src/app
