require!{
  gulp
  nib
}
$ = require(\gulp-load-plugins)!

gulp.task \styles, ->
  gulp.src("app/styles/main.styl")
    .pipe($.plumber(errorHandler: $.notify.onError("<%= error.stack %>")))
    .pipe($.stylus(use: [nib!])).pipe($.autoprefixer("last 1 version"))
    .pipe(gulp.dest(".tmp/styles"))

gulp.task \scripts, ->
  gulp.src("app/scripts/**/*.ls")
    .pipe($.plumber(errorHandler: $.notify.onError("<%= error.stack %>")))
    .pipe($.replace(\ARPA_UI_ARPA_SERVICE_URL, JSON.stringify(process.env.ARPA_UI_ARPA_SERVICE_URL || "http://demo.seco.tkk.fi/arpa/")))
    .pipe($.cached!)
    .pipe($.sourcemaps.init!)
    .pipe($.livescript(bare: false))
    .pipe($.sourcemaps.write("./tmp/maps"))
    .pipe(gulp.dest(".tmp/scripts"))

gulp.task \templates, ->
  gulp.src("app/**/*.jade")
    .pipe($.plumber(errorHandler: $.notify.onError("<%= error.stack %>")))
    .pipe($.cached!)
    .pipe($.sourcemaps.init!)
    .pipe($.pug(pretty: true))
    .pipe($.sourcemaps.write("./tmp/maps"))
    .pipe(gulp.dest(".tmp"))

gulp.task \clean, (cb) ->
  require(\del) <[.tmp dist]>, cb

gulp.task \build, (cb) ->
  require(\run-sequence) \clean, <[wiredep templates styles scripts]>, cb
