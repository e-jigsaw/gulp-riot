require! {
  \gulp-util : gutil
  through2: through
  riot: {compile}
}

module.exports = (opts)->
  transform = (file, encoding, callback)->
    if file.isNull! then return callback null, file
    if file.isStream! then return callback new gutil.PluginError 'gulp-article', 'Stream not supported'

    file.contents = new Buffer compile file.contents.toString!, opts
    splitedPath = file.path.split \.
    splitedPath[splitedPath.length - 1] = \js
    file.path = splitedPath.join \.
    callback null, file

  through.obj transform
