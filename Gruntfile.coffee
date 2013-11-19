module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		watch:
			app:
				files: [
					'src/coffee/**/*.coffee'
				]
				tasks: ['coffee:app', 'coffee:app_main', 'coffee:spec_src', 'jasmine']
			spec:
				files: [
					'test/coffee/**/*.coffee'
				]
				tasks: ['coffee:spec', 'jasmine']
		bower:
			install:
				options: 
					targetDir: './public/lib'
					layout: 'byComponent'
					install: true
					verbose: false
					cleanTargetDir: true
					cleanBowerDir: false
		clean:
			spec:
				src: 'spec_runner/**/*'
			build:
				src: 'public/js/*'
		coffee:
			app:
				options:
					join: true
				files: [
					'public/js/orderMaid.js' : [
						'src/coffee/*.coffee'
						'!src/coffee/main.coffee'
					]
				]
			app_main:
				files: [
					'public/js/main.js' : [ 'src/coffee/main.coffee' ]
				]
			spec_src:
				options:
					bare: true
				files: [
					expand: true
					cwd: 'src/coffee/'
					src: [
						'**/*.coffee'
						'!main.coffee'
					]
					dest: 'spec_runner/src'
					ext: '.js'
				]
			spec:
				files: [
					expand: true
					cwd: 'test/coffee/'
					src: ['**/*_spec.coffee']
					dest: 'spec_runner/spec'
					ext: '.js'
				]
		jasmine:
			helper:
				src: [
					'spec_runner/src/10_model.js'
					'spec_runner/src/50_helper.js'
				]
				options:
					vendor: [
						'public/lib/jquery/jquery.js'
						'public/lib/bootstrap/bootstrap.js'
						'public/lib/underscore/underscore-min.js'
						'public/lib/backbone/backbone-min.js'
						'public/lib/enchant.js/enchant.min.js'
					]
					specs: [
						'spec_runner/spec/50_helper_spec.js'
					]
					outfile: 'spec_runner/helperSpecRunner.html'
					keepRunner: true
			gameview:
				src: [
					'spec_runner/src/00*.js'
					'spec_runner/src/10*.js'
					'spec_runner/src/20_dom_view_screen.js'
					'spec_runner/src/21_gameview_main.js'
				]
				options:
					vendor: [
						'public/lib/jquery/jquery.js'
						'public/lib/bootstrap/bootstrap.js'
						'public/lib/underscore/underscore-min.js'
						'public/lib/backbone/backbone-min.js'
						'public/lib/enchant.js/enchant.min.js'
					]
					specs: [
						'spec_runner/spec/21_gameview_main_spec.js'
					]
					outfile: 'spec_runner/gameviewSpecRunner.html'
					keepRunner: true

	grunt.loadNpmTasks 'grunt-bower-task'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-jasmine'
	grunt.registerTask 'default', ['watch']
	grunt.registerTask 'build', ['clean:build', 'coffee:app', 'coffee:app_main']
	grunt.registerTask 'spec', ['clean:spec', 'coffee:spec_src', 'coffee:spec', 'jasmine']
	return
