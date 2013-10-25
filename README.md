== Georuby-ext [![Build Status](https://travis-ci.org/dryade/georuby-ext.png)](http://travis-ci.org/dryade/georuby-ext?branch=master) [![Dependency Status](https://gemnasium.com/dryade/georuby-ext.png)](https://gemnasium.com/dryade/georuby-ext) [![Code Climate](https://codeclimate.com/github/dryade/georuby-ext.png)](https://codeclimate.com/github/dryade/georuby-ext)

Georuby-ext is an extension to Ruby geometry libraries : 
- Rgeo
- GeoRuby
- Geokit
- Proj4j

It allows to <b>use them together</b>.

=== License

This project uses MIT-LICENSE.

Requirements
------------
 
This code has been run and tested on [Travis](http://travis-ci.org/afimb/chouette2?branch=master) with : 
* Ruby 1.8.7
* Ruby 1.9.3
* Ruby 2.0
* JRuby 1.7.2 with oraclejdk7, openjdk7, openjdk6

External Deps
-------------
On Debian/Ubuntu/Kubuntu OS : 
```sh
sudo apt-get install libproj-dev libgeos-dev libffi-dev
```

Installation
------------

Without bundler : 
gem install georuby-ext


With bundler add to your Gemfile : 
gem 'georuby-ext', '>=0.0.2'


Test
----

```sh
bundle exec rake spec
```

More Information
----------------
 
More information can be found on the [project website on GitHub](.). 
There is extensive usage documentation available [on the wiki](../../wiki).

Example Usage 
-------------

TODO ...

License
-------
 
This project is licensed under the MIT license, a copy of which can be found in the [LICENSE](./LICENSE.md) file.

Release Notes
-------------

The release notes can be found in [CHANGELOG](./CHANGELOG.md) file 
 
Support
-------
 
Users looking for support should file an issue on the GitHub [issue tracking page](../../issues), or file a [pull request](../../pulls) if you have a fix available.
