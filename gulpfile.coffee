gulp       = require 'gulp'
concat     = require 'gulp-concat'
coffee     = require 'gulp-coffee'
umd        = require 'gulp-umd-wrap'
plumber    = require 'gulp-plumber'
preprocess = require 'gulp-preprocess'
fs         = require 'fs'

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  dependencies = [
    {global: 'document',           native: true}
    {global: 'encodeURIComponent', native: true}]
  header = fs.readFileSync('source/__license__.coffee')
  
  gulp.src('source/provider.coffee')
    .pipe plumber()
    .pipe preprocess()
    .pipe umd({global: 'GoogleMapsAPI', dependencies, header})
    .pipe concat('provider.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('provider.js')
    .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
