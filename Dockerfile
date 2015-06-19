FROM ruby:1.9.3

RUN apt-get update \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8


RUN curl -Lo /tmp/Gemfile https://raw.githubusercontent.com/lalyos/lalyos.github.com/source/Gemfile
RUN cd /tmp && bundle install

