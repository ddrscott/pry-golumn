# Pry Golumn

Send results of raw SQL or command which responds to `to_sql` or `all.to_sql` to `golumn`.

Note: This only works under Postgres additional DB adapters maybe be created in the future.

## Usage

```ruby
# run plan SQL
golumn select * from pg_tables


# run model class
golumn People

# run model scope
golumn People.addresses
golumn People.where(zipcode: '60000')
```

<img src="https://user-images.githubusercontent.com/1975119/32610351-21120398-c528-11e7-8fab-5526988cc515.gif" alt="demo"/>

## Install Golumn Command

You'll need a working Python environment to get the `golumn` command
```sh
pip install golumn --upgrade
```

## Installation without Gemfile

Clone this repository to local file system and load the file via `.pryrc`

```sh
# clone the repo
cd /path/to/code
git clone https://github.com/ddrscott/pry-golumn.git

# be sure to replace `path/to/pry-golumn` with the real path
tee -a ~/.pryrc <<EOF
load '/path/to/pry-golumn/lib/pry-golumn.rb'
EOF
```

## Installation via Rubygems

```ruby
gem 'pry-golumn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pry-golumn

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ddrscott/pry-golumn.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
