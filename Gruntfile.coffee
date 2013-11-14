module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		watch:
			app:
				files: [
					'src/coffee/**/*.coffee'
				]
				tasks: ['coffee:app', 'coffee:spec_src', 'jasmine']
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
		coffee:
			app:
				options:
					join: true
				files: [
					'public/js/main.js' : ['src/coffee/*.coffee']
				]
			spec_src:
				options:
					bare: true
				files: [
					expand: true
					cwd: 'src/coffee/'
					src: ['**/*.coffee']
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
					'spec_runner/src/helper.js'
					'spec_runner/src/model.js'
				]
				options:
					vendor: [
						'public/lib/jquery/jquery.js'
						'public/lib/bootstrap/bootstrap.js'
						'public/lib/underscore/underscore-min.js'
						'public/lib/backbone/backbone-min.js'
					]
					specs: [
						'spec_runner/spec/helper_spec.js'
					]
					keepRunner: true

	grunt.loadNpmTasks 'grunt-bower-task'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-jasmine'
	grunt.registerTask 'default', ['watch']
	grunt.registerTask 'spec', ['coffee:spec_src', 'coffee:spec', 'jasmine']
	return
