gulp = require 'gulp'
coffee = require 'gulp-coffee'
espower = require 'gulp-espower'
mocha = require 'gulp-mocha'

gulp.task 'coffee', ->
  gulp.src 'src/*.coffee'
    .pipe coffee()
    .pipe gulp.dest('build/')

gulp.task 'default', ['coffee']
gulp.task 'watch', ['default'], ->
  gulp.watch paths.coffee, ['coffee']

gulp.task 'power-assert', ->
  gulp.src 'test/*.coffee'
    .pipe coffee()
    .pipe espower()
    .pipe gulp.dest('powered-test/')

gulp.task 'test', ['power-assert'], ->
  gulp.src 'powered-test/*.js'
    .pipe mocha()
