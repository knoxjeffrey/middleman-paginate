# Middleman::Paginate

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'middleman-paginate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install middleman-paginate

## Usage

Consider that middleman-paginate creates a page for each set of data sliced from your collection. This page is created by a template. In your config.rb

```ruby
paginate data.your_collection, "/episodes", "/templates/episodes.html", suffix: "/page/:num/index", per_page: 20
```

in your pagination template you'll find a collection named `items` with the objects for the specific page:

```ruby
- items.each do |episode|
  p= episode.title
```

You also have an object `pager` that offers some helpers to build the pagination links:

```ruby
- if pager.next_page
  = link_to "Next page", pager.page_path(pager.next_page)
- if pager.previous_page
  = link_to "Previous page", pager.page_path(pager.previous_page)
```

The final URLs will be:

```
http://127.0.0.1:4567/episodes/index.html
http://127.0.0.1:4567/episodes/page/2.html
http://127.0.0.1:4567/episodes/page/3.html
```

and so on.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/middleman-paginate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

