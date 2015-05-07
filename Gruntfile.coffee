# Javascript files created by Coffeescript during build.
# Order matters, as the concat task will merge them together.
coffeefiles = [
  "src/javascripts/app.coffee"
]

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    clean: 
      build: ["build/"]
      dist: ["dist/"]
    copy:
      build:
        files: [
          {src: "src/index.html", dest: "build/index.html"}
          {src: "src/address-explorer.css", dest: "build/address-explorer.css"}
        ] 
      dist:
        files: [
          {src: "src/index.html", dest: "dist/index.html"}
          {src: "src/address-explorer.css", dest: "dist/address-explorer.css"}
        ]
    coffee:
      build:
        options: 
          join: true
        files:
          "build/<%= pkg.name %>.js": coffeefiles
    concat: 
      build:
        src: [
          "src/javascripts/lib/jquery-2.1.4.js"
          "src/javascripts/lib/moment.js"
          "src/javascripts/lib/livestamp.js"
          "src/javascripts/lib/bignumber.js" 
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
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.registerTask 'default', [
    'clean'
    'copy'
    'coffee'
    'concat'
    'uglify'
  ]
  return