[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/guillaumebriday)

# Jsonapi::Scopes
This gem provides an easy way to use a filter query parameter from the [jsonapi specification](https://jsonapi.org/recommendations/#filtering).

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'jsonapi-scopes'
```

And then execute:
```bash
$ bundle
```

## Usage

### Filter
The gem add a `filter` method to define public scopes.
It acts as a regular scope.

```ruby
class Contact < ActiveRecord::Base
  include Jsonapi::Filter

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

### Sorting
The gem add `default_sort` and `sortable_fields` methods to control sort options. **Both are optional** and can be overriding in controllers.

```ruby
class Contact < ActiveRecord::Base
  include Jsonapi::Sort

  sortable_fields :lastname, :firstname # List of allowed attributes
  default_sort lastname: :desc, firstname: :asc # default hash with attributes and directions
end
```

You can use `apply_sort` in your controller :

```ruby
class ContactsController < ApplicationController
  def index
    @contacts = Contact.apply_sort(params)
  end
end
```

`apply_sort` accepts a second parameter to override data set with `sortable_fields` and `default_sort` for a specific controller.
```ruby
class ContactsController < ApplicationController
  def index
    @contacts = Contact.apply_sort(params, allowed: :full_name, default: { full_name: :desc })
    # Or @contacts = Contact.apply_sort(params, allowed: [:lastname, :full_name], default: { full_name: :desc })
  end
end
```

Then you can hit `/contacts?sort=lastname` to sort contacts by lastname.

Or use negative sort `/contacts?sort=-firstname` to sort by firstname in `desc` direction.

You can even combine multiple sort `/contacts?sort=lastname,-firstname`

## Contributing
Do not hesitate to contribute to the project by adapting or adding features ! Bug reports or pull requests are welcome.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
