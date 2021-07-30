FROM ruby:3

# Label of Docker Image (Rename)
LABEL Name=railized Version=1.0.0 

# Install
RUN apt-get update -qq

# Install ActiveStorage Image & Video Processing Requirements 
RUN apt-get install -y \
    nodejs postgresql-client imagemagick ffmpeg 

# Yarn Installation Script
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle update --bundler
RUN bundle install
COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
EXPOSE 3035

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]        