FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get install -y nodejs
RUN apt-get update && apt-get install yarn

ENV APP_ROOT /usr/local/web
RUN mkdir -p $APP_ROOT

WORKDIR $APP_ROOT

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

COPY package.json yarn.lock ./
RUN yarn

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]