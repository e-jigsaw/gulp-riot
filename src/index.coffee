gutil = require 'gulp-util'
through = require 'through2'
compiler = require 'riot/compiler'

module.exports = ->
  transform = (file, encoding, callback)->
    if file.isNull() then return callback null, file
    if file.isStream() then return callback new gutil.PluginError('gulp-article', 'Stream not supported')

    file.contents = new Buffer compiler file.contents.toString()
    file.path = file.path.replace /\.tag/, '.js'
    callback null, file

  through.obj transform
