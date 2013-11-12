orderMaid
=========

mini game on browser with coffee-script, enchant.js, backbone.js

## For Developers

### Setup

1. Install dependecies

	```
	bundle install --path vendor/bundle
	npm install
	bower install
	```

1. Build dependecies

	for enchant.js, example command with v0.8.0.
	Read github.com/wise9/enchant.js.

	```
	cd bower_components/enchant.js
	npm install
	grunt concat uglify lang
	```

1. Copy dependencies to dir 'public'

	this command run at orderMaid/

	```
	grunt bower:install
	```

### Build

```
grunt coffee:compileJoined
```

### Running

```
bundle exec rackup
```

Access to localhost:9292

## Libraries, Materials

### Libraries

- enchant.ttweet.js
	http://code.9leap.net/codes/show/16598

### Materials