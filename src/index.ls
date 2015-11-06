require! {
  \gulp-util : gutil
  through2: through
  riot: {compile, parsers}
}

module.exports = (opts = {})->
  transform = (file, encoding, callback)->
    | file.isNull! => callback null, file
    | file.isStream! => callback new gutil.PluginError \gulp-riot, 'Stream not supported'
    | otherwise =>
      if opts.parsers?
        Object.keys opts.parsers .forEach (x)-> Object.keys opts.parsers[x] .forEach (y)->
          parsers[x][y] = opts.parsers[x][y]
        delete opts.parsers

      try
        compiledCode = compile file.contents.toString!, opts
      catch err
        return callback new gutil.PluginError \gulp-riot, "Compiler Error: #{err}"

      if opts.modular
        compiledCode = """
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
      splitedPath = file.path.split \.
      splitedPath[*-1] = \js
      file.path = splitedPath.join \.
      callback null, file

  through.obj transform
