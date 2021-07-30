# Railized
An opinionated Rails on Docker template for rapid development.

Batteries Included:
- Ruby on Rails
- Postgres 
- Redis
- Docker

## Requirements
- [Docker](https://www.docker.com)

## Preconfigure (Optional)
Rename project to desired name.

/Dockerfile
```Dockerfile
# Label of Docker Image (Rename)
LABEL Name=PROJECT_NAME Version=1.0.0 
```

``` Dockerfile
...
WORKDIR /PROJECT_NAME
COPY Gemfile /PROJECT_NAME/Gemfile
COPY Gemfile.lock /PROJECT_NAME/Gemfile.lock
RUN bundle update --bundler
RUN bundle install
COPY . /PROJECT_NAME
...    
```

/entrypoint.sh
```bash
# Remove a potentially pre-existing server.pid for Rails.
rm -f /{PROJECT_NAME}/tmp/pids/server.pid
```

/docker-compose.yml
```yaml
...
  web:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/PROJECT_NAME
...
```

## Step 1: Install
Use the install script to create a new Rails app.

```bash
bin/install 
```

## Step 2: Database Configuration
Update config/database.yml file. Add host, username, and password to default definition.

```yaml 
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: postgres
  password: password
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

## Step 3: Cable Configuration 
Update config/cable.yml file. Add url and change adapter to Redis to default definition.. 

```yaml
development:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://redis:6379/1" } %>
```

## Step 4: Required Gems
Uncomment Redis and ImageProcessing gems from Gemfile.

```ruby 
gem 'redis'
gem 'image_processing'
```

## Step 5: Run
```bash
docker-compose up
```

## Changelog
- v0.0.1 Initial Version

## LICENSE

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>