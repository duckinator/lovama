# Lovama

lo\[cal ]va\[riable ]ma\[nipulation]: adds `local_variable_get` and `local_variable_set`.

## Installation

Add this line to your application's Gemfile:

    gem 'lovama'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lovama

## Usage

```ruby
require 'lovama'

foo = true

foo #=> true
local_variable_get(:foo) #=> true

local_variable_set(:foo, false) #=> false

foo #=> false
local_variable_get(:foo) #=> false
```

## Limitations

You have to declare the variable before setting it.

```ruby
foo = true # Setting it to *something* here is *required*.
local_variable_set(:foo, false)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/lovama/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
