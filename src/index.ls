require! {
  \gulp-util : gutil
  through2: through
  riot: {compile, parsers}
}

module.exports = (opts = {})->
  transform = (file, encoding, callback)->
    | file.is-null! => callback null, file
    | file.is-stream! => callback new gutil.PluginError \gulp-riot, 'Stream not supported'
    | otherwise =>
      if opts.parsers?
        Object
          .keys opts.parsers
          .for-each (x)->
            Object
              .keys opts.parsers[x]
              .for-each (y)-> parsers[x][y] = opts.parsers[x][y]
        delete opts.parsers

      try
        compiled-code = compile file.contents.to-string!, opts, file.path
      catch err
        return callback new gutil.PluginError \gulp-riot, "#{file.path}: Compiler Error: #{err}"

      if opts.modular
        compiled-code = """
          (function(tagger) {
            if (typeof define === 'function' && define.amd) {
              define(['riot'], function(riot) { tagger(riot); });
            } else if (typeof module !== 'undefined' && typeof module.exports !== 'undefined') {
              tagger(require('riot'));
            } else {
              tagger(window.riot);
            }
          })(function(riot) {
          #{compiledCode}

          });
        """

      file.contents = new Buffer compiledCode
      splited-path = file.path.split \.
      splited-path[*-1] = \js
      file.path = splited-path.join \.
      callback null, file

  through.obj transform
