var gulp = require('gulp'),
  runSequence = require('run-sequence'),
  browserSync = require('browser-sync').create(),
  del = require('del'),
  compass = require('gulp-compass');

gulp.task('default', function() {
  return runSequence(['clean'], ['build'], ['serve', 'watch']);
});

gulp.task('clean', function(callback) {
  return del('./public/', callback);
});

gulp.task('build', function(callback) {
  return runSequence(['compass', 'html','lib','javascripts'], callback);
});

gulp.task('compass', function() {
  return gulp.src('./src/**/*.scss')
    .pipe(compass({
      config_file: './config.rb',
      css: 'src/stylesheets',
      sass: 'src/sass'
    }))
    .pipe(gulp.dest('./public/stylesheets/'));
});

gulp.task('html', function() {
  return gulp.src('./src/**/*.html')
    .pipe(gulp.dest('./public/'));
})

gulp.task('lib', function(){
  return gulp.src('./src/lib/**/*')
    .pipe(gulp.dest('./public/lib/'));
})

gulp.task('javascripts', function(){
  return gulp.src('./src/javascripts/**/*')
    .pipe(gulp.dest('./public/javascripts/'));
})

gulp.task('serve', function() {
  browserSync.init({
    server: './public',
    port: 8888
  });
});

gulp.task('reload', function() {
  return browserSync.reload();
});

gulp.task('watch', function() {
  return gulp.watch([
    './src/**/*.html',
    './src/**/*.scss'
  ], function() {
    return runSequence(['build'], ['reload']);
  })
});
