# pageintro.js

A simple jQuery plugin for new feature introduction and step-by-step users guide for your website and project.

![Demo screenshot](http://git.oschina.net/uploads/images/2017/0329/174117_920a5a04_568.gif "Demo screenshot")

## Build

You need to install compass and coffee-script：

	gem install compass
	npm install -g coffee-script

After installation, you need to run the following command to compile the source files:

	compass compile
	coffee -o dist -c src/pageintro.coffee

At last, you can find the output files in the `dist` directory.

## Example

``` javascript
var options = {
  container: 'body',
  spacing: 20,
  actions: {
    next: {
      text: 'Next',
      class: 'your custom button class'
    },
    finish: {
      text: 'Finish',
      class: 'your custom button class'
    }
  },
  entries: [
    {
      selector: '#example',
      text: 'this is example',
      onEnter: function () {
        console.log('enter');
      },
      onExit: function () {
        console.log('exit');
      }
    }, {
      selector: '#step1',
      text: 'text for step 1'
    }, {
      selector: '#step2',
      text: 'text for step 2'
    }
  ]
}
PageIntro.init(options);
PageIntro.start();
```

## Usage

### PageIntro.init()

Initialize the pageintro, you need to specify the configuration options here.

### PageIntro.start()

Start page introduction show

### PageIntro.finish()

Finish page introduction show


