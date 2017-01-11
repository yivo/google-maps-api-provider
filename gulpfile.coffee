gulp       = require 'gulp'
concat     = require 'gulp-concat'
coffee     = require 'gulp-coffee'
iife       = require 'gulp-iife-wrap'
plumber    = require 'gulp-plumber'
preprocess = require 'gulp-preprocess'

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  dependencies = [{global: 'document', native: true}]
  gulp.src('source/provider.coffee')
    .pipe plumber()
    .pipe preprocess()
    .pipe iife({global: 'GoogleMapsAPI', dependencies})
    .pipe concat('provider.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('provider.js')
    .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
