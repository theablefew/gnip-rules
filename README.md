= gnip-rules

Provides a quick and easy way to manage your rules via Gnip Rules API. 

== Installation

```ruby
 gem 'gnip-rules'
```

== Configuration

There are two ways you can provide credentials to the gnip-api gem. 

* Directly to Gnip::Rules.new( "chieflarl@larlbang.com", "larl!operator" ,'https://stream.gnip.com:443/accounts/YOUR_ACCOUNT/publishers/twitter/streams/track/prod' )
* Via a configuration file at config/gnip.yml 

```ruby
 development: &development
   username: chieflarl@larlbang.com
   password: larl!operator 
   streaming_url:'https://stream.gnip.com:443/accounts/YOUR_ACCOUNT/publishers/twitter/streams/track/prod'
```

== Usage

```ruby
 @gnip_rules = Gnip::Rules.new
```

=== Adding

```ruby
  rules = [Gnip::Rule.new "larl -bang", Gnip::Rule.new "#larloperator", Gnip::Rule.new "larlygag" , "some_tag"]
  response = @gnip_rules.add( rules )
  p response #=> 201 Created
```

=== Removing

```ruby
  rules = [Gnip::Rule.new "larl -bang", Gnip::Rule.new "#larloperator"]
  response = @gnip_rules.remove( rules )
  p response #=> 200 OK
```

=== Listing

```ruby
  response = @gnip_rules.list
  p response #=> {"rules": {"value":"larl -bang", "value":"#larloperator"} }
```

=== Removing All Rules

This is really just for convienience while testing. You probably shouldn't ever use this in production.

```ruby
  response = @gnip_rules.delete_all!
  p response #=> 200 OK
  @gnip.list["rules"].empty? #=> true
```

== Running Tests

Make sure you have the config file mentioned above at config/gnip.yml

```ruby
 rake test
```

== Contributing to gnip-rules
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2011 The Able Few. See LICENSE.txt for
further details.


