module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		watch:
			files: ['src/coffee/**/*.coffee']
			tasks: 'coffee:compileJoined'
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
			compile:
				files: [
					expand: true
					cwd: 'src/coffee/'
					src: ['**/*.coffee']
					dest: 'public/js/'
					ext: '.js'
				]
			compileJoined:
				options:
					join: true
				files: [
					'public/js/main.js' : ['src/coffee/*.coffee']
				]

	grunt.loadNpmTasks 'grunt-bower-task'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.registerTask 'default', ['watch']
	return
