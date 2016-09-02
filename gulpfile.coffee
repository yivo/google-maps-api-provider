gulp = require('gulp')
require('gulp-lazyload')
  concat:     'gulp-concat'
  coffee:     'gulp-coffee'
  iife:       'gulp-iife-wrap'
  uglify:     'gulp-uglify'
  rename:     'gulp-rename'
  del:        'del'
  plumber:    'gulp-plumber'
  preprocess: 'gulp-preprocess'

gulp.task 'default', ['build', 'watch'], ->

dependencies = [
  {global: 'document', native: yes}
  {global: 'Date',     native: yes}
]

gulp.task 'build', ->
  gulp.src('source/provider.coffee')
  .pipe plumber()
  .pipe preprocess()
  .pipe iife {dependencies, global: 'GoogleMapsAPI'}
  .pipe concat('provider.coffee')
  .pipe gulp.dest('build')
  .pipe coffee()
  .pipe concat('provider.js')
  .pipe gulp.dest('build')

gulp.task 'build-min', ['build'], ->
  gulp.src('build/provider.js')
  .pipe uglify(output: {width: 80, max_line_len: 80})
  .pipe rename('provider.min.js')
  .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
