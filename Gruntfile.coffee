# Javascript files created by Coffeescript during build.
# Order matters, as the concat task will merge them together.
coffeefiles = [
  "src/javascripts/utils.cjsx"
  "src/javascripts/sidebar.cjsx"
  "src/javascripts/address_view.cjsx"
  "src/javascripts/account_view.cjsx"
  "src/javascripts/activity.cjsx"
  "src/javascripts/block_view.cjsx"
  "src/javascripts/app.cjsx" 
]

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    clean: 
      build: ["build/"]
      dist: ["dist/"]
    sass: 
      build: 
        files: 
          "build/address-explorer.css": "src/css/address-explorer.scss"
      dist:
        files:
          "dist/address-explorer.css": "src/css/address-explorer.scss"
    copy:
      build:
        files: [
          {src: "src/index.html", dest: "build/index.html"}
          {expand: true, cwd: 'src/img/', src: ['**'], dest: 'build/img/'}
        ] 
      dist:
        files: [
          {src: "src/index.html", dest: "dist/index.html"}
          {expand: true, cwd: 'src/img/', src: ['**'], dest: 'dist/img/'}
        ]
    cjsx:
      build:
        options: 
          join: true
        files:
          "build/<%= pkg.name %>.js": coffeefiles
    concat: 
      build:
        src: [
          "src/javascripts/lib/react-0.13.3.js"
          "src/javascripts/lib/jquery-2.1.4.js"
          "src/javascripts/lib/moment.js"
          "src/javascripts/lib/livestamp.js"
          "src/javascripts/lib/bignumber.js" 
          "src/javascripts/lib/jquery-bigtext.js"
          "src/javascripts/lib/jquery.textFit.js"
          "build/<%= pkg.name %>.js"
        ]
        dest: "build/<%= pkg.name %>.js"
    uglify:
      options: banner: '/*! <%= pkg.name %> <%= grunt.template.today("dd-mm-yyyy") %> */\n'
      dist: 
        files: 
          'dist/<%= pkg.name %>.js': [
            "build/<%= pkg.name %>.js"
          ]
    watch: 
      build: 
        files: ["./Gruntfile.coffee", 'src/**/*'] 
        tasks: ["default"] 
        options: 
          interrupt: true
          spawn: false

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-coffee-react'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-sass'
  grunt.registerTask 'default', [
    'clean'
    'sass'
    'copy'
    'cjsx'
    'concat'
  ]
  grunt.registerTask 'dist', ["default", "uglify"]
  return