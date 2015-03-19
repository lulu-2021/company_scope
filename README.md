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

Getting started
===============
There are two steps in adding multi-tenancy/company to your app with company_scope:

1. setting the current tenant and
2. scoping your models.

Setting the current tenant
--------------------------
There are three ways to set the current tenant:

1. by using the subdomain to lookup the current tenant,
2. by setting  the current tenant in the controller, and
3. by setting the current tenant for a block.

### Use the subdomain to lookup the current tenant ###

```ruby
class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:account, :subdomain)
end
```






## Development


## Contributing

1. Fork it ( https://github.com/[my-github-username]/company_scope/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
