# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

### Starting the application

```bash
docker-compose -f docker-compose.yml up
# http://localhost:3000
```


### Pushing a message to Poxa

```
rails console
```

```ruby
channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
channels_client.trigger('channel', 'event', message: 'Fasten your seatbelt!');
```
