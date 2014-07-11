module.exports = (grunt) ->
    'use strict'

    # Load required Grunt tasks.
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-sass'


    # Load the build configuration file.
    userConfig = require './build.config.js'

    # Config object Grunt uses to give each plugin
    # its instructions.
    taskConfig =
        
        # We read in our 'package.json' file to get name
        # and version.  It's there so we don't have to 
        # do it here.
        pkg: grunt.file.readJSON 'package.json'

        # Remove generated files and folders. Basically,
        # just the build folders.
        clean:
            build:
                ['<%= dev_dir %>/*']
            bin:
                # ['bin/*']
                ['<%= prod_dir %>/*']


    # Add the userConfig to taskConfig
    grunt.initConfig(grunt.util._.extend(taskConfig, userConfig))

    grunt.registerTask 'default', ['clean'], ->
        grunt.log.writeln("Cleaning Build and Bin...")
                
                
