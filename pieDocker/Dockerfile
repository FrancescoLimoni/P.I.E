FROM ruby:2.5

RUN apt-get update && \
  apt-get install -y \
    libfox-1.6-dev \
    libxrandr-dev \
    pkg-config

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN git clone https://github.com/FrancescoLimoni/P.I.E.git

WORKDIR /P.I.E

COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN gem install --verbose fxruby
RUN gem install launchy

COPY . .

CMD ["ruby", "./pieProject/code/Main.rb"]
