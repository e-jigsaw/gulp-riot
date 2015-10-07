require! {
  \gulp-util : gutil
  through2: through
  riot: {compile}
}

module.exports = (opts = {})->
  transform = (file, encoding, callback)->
    if file.isNull! then return callback null, file
    if file.isStream! then return callback new gutil.PluginError \gulp-riot, 'Stream not supported'

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
    splitedPath[splitedPath.length - 1] = \js
    file.path = splitedPath.join \.
    callback null, file

  through.obj transform
