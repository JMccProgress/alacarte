# Alacarte

Alacarte is a tool to help the Chef Support team create representative test environments


## Installation

!! we are still under development for this.

to initially try this out, clone down this repo and then run ./exe/alacarte

```bash
git clone https://github.com/JMccProgress/alacarte
cd alacarte
./exe/alacarte
```

### future install options

Add this line to your application's Gemfile:

```ruby
gem 'alacarte'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install alacarte

## Usage


!! under development

```bash
./exe/alacarte
```

## Testing tips

To update the code and then test, once you have made the relevant changes, rake and gem install before re-running. For example, if you were editing the `waiter` cli function

```bash
rake build && gem install pkg/alacarte-0.1.0.gem
./exe/alacarte waiter
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JMccProgress/alacarte.

## License
[MIT](https://choosealicense.com/licenses/mit/)
