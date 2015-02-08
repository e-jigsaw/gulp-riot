gutil = require 'gulp-util'
through = require 'through2'
{compile} = require 'riot'

module.exports = (opts)->
  transform = (file, encoding, callback)->
    if file.isNull() then return callback null, file
    if file.isStream() then return callback new gutil.PluginError('gulp-article', 'Stream not supported')

    file.contents = new Buffer compile file.contents.toString(), opts
    splitedPath = file.path.split('.')
    splitedPath[splitedPath.length - 1] = 'js'
    file.path = splitedPath.join('.')
    callback null, file

  through.obj transform
