
module.exports = (grunt) ->
    'use strict'

    # Load required Grunt tasks.
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-watch'


    # Load the build configuration file.
    userConfig = require './build.config.js'

    # Load custom packages
    sb = require './snocketBuilder.js'

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
            dev:
                ['<%= dev_dir %>/*']
            prod:
                ['<%= prod_dir %>/*']
            htmlonly:
                ['<%= dev_dir %>/*.html']

        copy:
            dev:
                # Straight Copies (i.e. index.html, vendor/
                # We don't need to copy over index.html, because
                # the buildAssets and snocketBuilder will do that.
                files: [
                    nonull:  true # Let's you see errors if no file was found.
                    expand:  true # Let's you give an array of values
                    src:     [
                        'vendor/**/bootstrap/*.js'
                        'vendor/jquery/dist/*.js'
                        'vendor/jquery/dist/*.map'
                    ]
                    dest:    '<%= dev_dir %>/'
                    cwd:     '<%= src_dir %>/'
                ]
            htmlonly:
                # Copy html only.
                files: [
                    nonull: true
                    expand: true
                    src: ['*.html']
                    dest: '<%= dev_dir %>/'
                    cwd: '<%= src_dir %>'
                ]
        sass:
            dev:
                options:
                    style:      'expanded'
                    sourcemap:  true
                    compass:    true
                files: [
                    expand: true
                    cwd: '<%= src_dir %>/common/'
                    src: ['*.scss']
                    dest: '<%= dev_dir %>/css/'
                    ext: '.css'
                ]

        _watch_:
            html:
                files: ['<%= src_dir %>/index.html']
                tasks: ['clean:htmlonly', 'copy:htmlonly']
            sass:
                files: ['<%= src_dir %>/common/*.scss']
                tasks: ['sass:dev']
            




    # Add the userConfig to taskConfig
    grunt.initConfig(grunt.util._.extend(taskConfig, userConfig))


    grunt.registerTask 'default', ['clean:dev', 'buildAssets', 'copy:dev', 'sass:dev']



    # Example of how we can write our own logs between tasks... Well almost
    grunt.registerTask 'verbose', ->
        grunt.log.writeln("Clean up your toys...")
        grunt.task.run('clean:dev')

        grunt.log.writeln("Duplicate your Toys...")
        grunt.task.run('copy:dev')

        grunt.log.writeln("Profit")
        grunt.task.run('sass:dev')

    grunt.renameTask 'watch', '_watch_'
    grunt.registerTask 'watch', ['default', '_watch_']

    # Custom Asset Builder using 
    grunt.registerTask 'buildAssets', ->
        sb.build('src/vendor/bootstrap-sass-twbs/vendor/assets/javascripts/bootstrap.js', 'src/index.html', 'build/index.html')
