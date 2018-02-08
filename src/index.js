'use strict';

import PluginError from 'plugin-error';
import * as riot from 'riot';
import through from 'through2';

const PLUGIN_NAME = 'gulp-riot';

module.exports = function(options = {}) {
  if (options.parsers) {
    Object.keys(options.parsers).forEach(x => {
      Object.keys(options.parsers[x]).forEach(y => {
        riot.parsers[x][y] = options.parsers[x][y];
      });
    });
    delete options.parsers;
  }

  return through.obj(function(file, encoding, callback) {
    if (file.isNull()) {
      return callback(null, file);
    }

    if (file.isStream()) {
      this.emit(
        'error',
        new PluginError(PLUGIN_NAME, 'Streaming not supported')
      );
      return callback();
    }

    let compiledCode;

    try {
      compiledCode = riot.compile(file.contents.toString(), options, file.path);
    } catch (err) {
      this.emit(
        'error',
        new PluginError(PLUGIN_NAME, `${file.path}: Compiler Error: ${err}`)
      );
    }

    if (options.modular) {
      compiledCode = `(function(tagger) {\n  if (typeof define === 'function' && define.amd) {\n    define(['riot'], function(riot) { tagger(riot); });\n  } else if (typeof module !== 'undefined' && typeof module.exports !== 'undefined') {\n    tagger(require('riot'));\n  } else {\n    tagger(window.riot);\n  }\n})(function(riot) {\n${compiledCode}\n\n});`;
    }

    file.contents = new Buffer(compiledCode);
    file.extname = '.js';
    this.push(file);

    callback();
  });
}
