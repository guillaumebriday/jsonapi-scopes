[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/guillaumebriday)

# Jsonapi::Scopes
This gem provides an easy way to use a filter query parameter from the [jsonapi specification](https://jsonapi.org/recommendations/#filtering).

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'jsonapi-scopes', git: 'https://github.com/guillaumebriday/jsonapi-scopes.git'
```

And then execute:
```bash
$ bundle
```

## Usage
The gem add a `filter` method to define public scopes.
It acts as a regular scope.

```ruby
class Contact < ActiveRecord::Base
  include Jsonapi::Scopes

  # Respond to `apply_filter`
  filter :first_name, ->(value) {
    where(first_name: value)
  }

  # Do NOT respond to `apply_filter`
  scope :last_name, ->(value) {
    where(last_name: value)
  }
end
```

You can use `apply_filter` in your controller to use the scopes defined with the previous `filter` method :

```ruby
class ContactsController < ApplicationController
  def index
    @contacts = Contact.apply_filter(params)
  end
end
```

Then you can hit `/contacts?filter[first_name]=Bruce` to filter contacts where the last name exactly match `Bruce`.

But `/contacts?filter[last_name]=Wayne` will be completely ignored.


## Contributing
Do not hesitate to contribute to the project by adapting or adding features ! Bug reports or pull requests are welcome.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
