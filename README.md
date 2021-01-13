# Seibii::Http
[![Circle CI](https://circleci.com/gh/seibii/seibii-http.svg?style=shield)](https://circleci.com/gh/seibii/seibii-http)
[![codecov](https://codecov.io/gh/seibii/seibii-http/branch/master/graph/badge.svg)](https://codecov.io/gh/seibii/seibii-http)
![GitHub](https://img.shields.io/github/license/seibii/seibii-http.svg)

## Installation

```ruby
gem 'seibii-http'
```

## Usage

### Base client
```ruby
def get
  Seibii::Http::Clients::Base
    .new(logger: ->() { |log| Rails.logger.debug(log) }) # logger is optional
    .request(
       method: :get, # required
       uri: URI.parse('https://example.com/example'), # required
       request_body: nil, # optional
       headers: { Accept: '*/*' }, # optional
       need_verify_cert: false # optional
    ) #=> response body String
rescue Seibii::Http::ClientError => e # 404 will not raise exception but just return nil response
  p e
  p e.response.status #=> 400..499
  p e.response.body
rescue Seibii::Http::ServerError => e
  p e
  p e.response.status #=> 500..599
  p e.response.body
end
```

### Json client
- `{ Content-Type: 'application/json`, Accept: 'application/json'}` headers will be added.
- You can use hash to make request parameters and receive response

```ruby
def post
  Seibii::Http::Clients::Json
    .new(logger: ->() { |log| Rails.logger.debug(log) }) # logger is optional
    .request(
       method: :post, # required
       uri: URI.parse('https://example.com/example'), # required
       params: { a: 'b', c: 'd' }, # optional
       headers: { Authorization: 'Bearer token' }, # optional
       need_verify_cert: false # optional
    ) #=> response json hash
rescue Seibii::Http::ClientError => e # 404 will not raise exception but just return nil response
  p e
  p e.response.status #=> 400..499 
  p e.response.body
rescue Seibii::Http::ServerError => e
  p e
  p e.response.status #=> 500..599
  p e.response.body
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/unhappychoice/seibii-http. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Seibii::Http project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/unhappychoice/seibii-http/blob/master/CODE_OF_CONDUCT.md).
