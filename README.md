# CompanyScope

This is a simple solution to scoping a rails project for multi-tenancy. It is based on the default_scope
in Active Record. Currently it uses a fixed model called company for the account/scoping.

Since the whole process needs a thread_safe way to store the current company identifier (such as a subdomain) as a class attribute, the gem uses the RequestStore gem to store this value.

Thread.current is the usual way to handle this but this is not entirely compatible with all ruby application servers - especially the Java based ones. RequestStore is the solution that works in all such application servers.

## Travis CI

[![Build Status](https://travis-ci.org/netflakes/company_scope.svg?branch=master)](https://travis-ci.org/netflakes/company_scope)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'company_scope'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install company_scope

## Usage

NB: This gem is currently under development and has not been published officially!
(use at your own risk..)

## Development


## Contributing

1. Fork it ( https://github.com/[my-github-username]/company_scope/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
