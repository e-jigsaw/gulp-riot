gulp-riot  [![npm version](https://badge.fury.io/js/gulp-riot.svg)](http://badge.fury.io/js/gulp-riot) [![wercker status](https://app.wercker.com/status/be2b2fa4c806197c9cade9b1a5ff8308/s/master "wercker status")](https://app.wercker.com/project/bykey/be2b2fa4c806197c9cade9b1a5ff8308)
=========

[![dependency Status](https://david-dm.org/e-jigsaw/gulp-riot/status.svg)](https://david-dm.org/e-jigsaw/gulp-riot) [![devDependency Status](https://david-dm.org/e-jigsaw/gulp-riot/dev-status.svg)](https://david-dm.org/e-jigsaw/gulp-riot#info=devDependencies)

[![NPM](https://nodei.co/npm/gulp-riot.png?downloadRank=true&downloads=true)](https://www.npmjs.com/package/gulp-riot)

[![Issue Stats](http://issuestats.com/github/e-jigsaw/gulp-riot/badge/issue?style=flat)](http://issuestats.com/github/e-jigsaw/gulp-riot)
[![Issue Stats](http://issuestats.com/github/e-jigsaw/gulp-riot/badge/pr?style=flat)](http://issuestats.com/github/e-jigsaw/gulp-riot)

gulp plugin for riot

# Usage

This plugin compile [riot](https://github.com/muut/riotjs)'s `.tag` files.

## Example

`example.tag`:

```jsx
<example>
  <p>This is { sample }</p>

  this.sample = 'example'
</example>
```

`gulpfile.babel.js`:

```js
import gulp from 'gulp';
import riot from 'gulp-riot';

gulp.task('riot', ()=> {
  gulp.src('example.tag')
      .pipe(riot())
      .pipe(gulp.dest('dest'));
});
```

Run task:

```sh
% gulp riot
% cat example.js
riot.tag('example', '<p>This is { sample }</p>', function(opts) {
  this.sample = 'example'
})
```

## Compile options

This plugin can give riot's compile options.

```js
  gulp.src('example.tag')
      .pipe(riot({
        compact: true // <- this
      }))
      .pipe(gulp.dest('dest'));
```

### Available option

* compact: `Boolean`
  * Minify `</p> <p>` to `</p><p>`
* whitespace: `Boolean`
  * Escape `\n` to `\\n`
* expr: `Boolean`
  * Run expressions through parser defined with `--type`
* type: `String, coffeescript | typescript | cs | es6 | livescript | none`
  * JavaScript parser
* template: `String, jade`
  * Template parser
  * See more: https://muut.com/riotjs/compiler.html
* modular: `Boolean`
  * For AMD and CommonJS option
  * See more: http://riotjs.com/guide/compiler/#pre-compilation
* parsers: `Object`
  * Define custom parsers
  * css: `Function`
    * See more: http://riotjs.com/api/compiler/#css-parser
  * js: `Function`
    * See more: http://riotjs.com/api/compiler/#js-parser
  * html: `Function`
    * See more: http://riotjs.com/api/compiler/#html-parser


# Installation

```sh
% npm install gulp-riot
```

# Requirements

* Node.js
* gulp

# Build

```sh
% npm run build
```

# Test

```sh
% npm test
```

# Author

* jigsaw (http://jgs.me, [@e-jigsaw](http://github.com/e-jigsaw))
* And contributors!

# License

MIT

The MIT License (MIT)

Copyright (c) 2015 Takaya Kobayashi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
