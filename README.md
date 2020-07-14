[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/guillaumebriday)
![](https://github.com/guillaumebriday/jsonapi-scopes/workflows/Lint/badge.svg)
![](https://github.com/guillaumebriday/jsonapi-scopes/workflows/Test/badge.svg)
[![](https://img.shields.io/gem/dt/jsonapi-scopes.svg)](https://rubygems.org/gems/jsonapi-scopes)
[![](https://img.shields.io/gem/v/jsonapi-scopes.svg)](https://rubygems.org/gems/jsonapi-scopes)
[![](https://img.shields.io/github/license/guillaumebriday/jsonapi-scopes.svg)](https://github.com/guillaumebriday/jsonapi-scopes)

# Jsonapi::Scopes
This gem provides a set of methods which allows you to include, filter and sort an ActiveRecord relation based on a request. It's built to be a simple, robust and scalable system. It follows the [JSON:API specification](https://jsonapi.org/) as closely as possible.

It's also an unopinionated solution to help you follow the `JSON:API specification`. It doesn't care about how you want to handle the results.

Moreover, it integrates seamlessly into your Rails application while not being a full library.

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
This gem supports [filtering](https://jsonapi.org/format/#fetching-filtering).

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

You can use `apply_filter` in your controller to use the scopes defined with the previous `filter` method:

```ruby
class ContactsController < ApplicationController
  def index
    @contacts = Contact.apply_filter(params)
  end
end
```

Then you can hit `/contacts?filter[first_name]=Bruce` to filter contacts where the first name exactly match `Bruce`.

You can specify multiple matching filter values by passing a comma separated list of values: `/contacts?filter[first_name]=Bruce,Peter` will returns contacts where the first name exactly match `Bruce` or `Peter`.

But `/contacts?filter[last_name]=Wayne` will be completely ignored.

### Sorting
This gem supports [sorting](https://jsonapi.org/format/#fetching-sorting).

The gem add `default_sort` and `sortable_fields` methods to control sort options. They can be overridden in controllers.

```ruby
class Contact < ActiveRecord::Base
  include Jsonapi::Sort

  sortable_fields :lastname, :firstname # List of allowed attributes
  default_sort lastname: :desc, firstname: :asc # default hash with attributes and directions
end
```

You can use `apply_sort` in your controller:

```ruby
class ContactsController < ApplicationController
  def index
    @contacts = Contact.apply_sort(params)
    @contacts = Contact.apply_sort # to only apply default sort
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


### Included relationships
This gem supports [request include params](https://jsonapi.org/format/#fetching-includes). It's very useful when you need to load related resources on client side.

```ruby
class Post < ActiveRecord::Base
  include Jsonapi::Include

  has_many :comments
  belongs_to :author

  allowed_includes 'comments', 'author.posts' # List of allowed includes
end
```

You can use `apply_include` in your controller:

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.apply_include(params)
  end
end
```

`apply_include` accepts a second parameter to override data set with `allowed_includes` for a specific controller.
```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.apply_include(params, allowed: 'comments') # to allow only comments.
    # Or @posts = Post.apply_include(params, allowed: ['comments', 'author'])
  end
end
```

Then you can hit `/posts?include=comments`. You can even combine multiple includes like `/posts?include=comments,author`.

The gem only handle `include` on the ActiveRecord level. If you want to serialize the data, you must do it in your controller.

#### Nested relationships

You can load nested relationships using the dot `.` notation:

`/posts?include=author.posts`.

### Rescuing a Bad Request in Rails

Jsonapi::scope raises a `Jsonapi::InvalidAttributeError` you can [rescue_from](https://guides.rubyonrails.org/action_controller_overview.html#rescue-from) in your `ApplicationController`.

If you want to follow the specification, you **must** respond with a `400 Bad Request`.

```ruby
class ApplicationController < ActionController::Base
 rescue_from Jsonapi::InvalidAttributeError, with: :json_api_bad_request

 private

  def json_api_bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
```

## Contributing
Do not hesitate to contribute to the project by adapting or adding features ! Bug reports or pull requests are welcome.

## Credits

Inspired by:

+ [https://github.com/stefatkins/rails-starter-api](https://github.com/stefatkins/rails-starter-api)
+ [https://github.com/cerebris/jsonapi-resources](https://github.com/cerebris/jsonapi-resources)

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
