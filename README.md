gulp-init-browserify
====

Overview

## Description

It is a project of the minimum configuration to the browserify using a gulp of build tools

## Install

### install gulp

```shell
$ npm install -g gulp
```

### install bower

```shell
$ npm install -g bower
```

### install npm package

```shell
$ cd projectName
$ npm install
```

### install bower package

```shell
$ cd projectName
$ bower install
```

Become a directory structure such as:

```
├── app
│   ├── bower_components
│   ├── index.html
│   └── javascripts/stylesheets
├── node_modules
│   └── packages
├── .bowerrc
├── .git
├── .gitignore
├── README.md
├── bower.json
├── gulpfile.coffee
└── package.json
```

---

## SCSS Description

## development.scss

It is scss file that developers use

## style.scss

It is scss file that Designers use

## Usage

## build

```
$ gulp watch
```

## release build

minify the css and javascript

```
$ gulp watch --release
```

http://localhost:4567/ opens in browser

Chrome Addon
[livereload](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei)


## Other

Modify the /src/javascripts/*.coffee when you want to modify the JavaScript
Modify /src/stylesheets/*.scss when you want to modify the CSS

## Licence

```
The MIT License (MIT)

Copyright (c) 2014 hisasann
```

## Author

[hisasann](https://github.com/hisasann)