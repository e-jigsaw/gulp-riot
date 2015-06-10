require! {
  gulp
  \gulp-livescript : lsc
  \gulp-espower : espower
  \gulp-mocha : mocha
}

gulp.task \ls, ->
  gulp.src \src/*.ls
    .pipe lsc bare: true
    .pipe gulp.dest \build

gulp.task \default, [\ls]

gulp.task \power-assert, ->
  gulp.src \test/*.ls
    .pipe lsc!
    .pipe espower!
    .pipe gulp.dest \powered-test/

gulp.task \test, [\power-assert], ->
  gulp.src \powered-test/*.js
    .pipe mocha!
