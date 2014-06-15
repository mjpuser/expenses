var haml = require('haml'),
	coffee = require('coffee-script'),
	fs = require('fs');

module.exports = function(grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		watch: {
			haml: {
				files: 'haml/**/*.haml',
				tasks: ['default']
			},
			coffee: {
				files: 'coffee/**/*.coffee',
				tasks: ['default']
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.task.registerTask('clean', 'delete target director', function() {
		grunt.file.delete('target');
	});

	grunt.task.registerTask('copy:html', 'copy html files', function() {
		grunt.file.recurse('html', function(path) {
			grunt.file.copy(path, path.replace(/^html/, 'target'));
		});
	});

	grunt.task.registerTask('copy:dependencies', 'move bower dependencies', function() {
		grunt.file.copy('bower_components/requirejs/require.js', 'target/js/lib/require.js');
		grunt.file.copy('bower_components/backbone/backbone.js', 'target/js/lib/backbone.js');
		grunt.file.copy('bower_components/lodash/dist/lodash.js', 'target/js/lib/lodash.js');
		grunt.file.copy('bower_components/jquery/dist/jquery.js', 'target/js/lib/jquery.js');
	});

	grunt.task.registerTask('compile:haml', 'compile haml templates', function() {
		grunt.file.recurse('haml', function(path) {
			if(!/\.haml$/.test(path)) {
					return;
			}
			var lines = ('' + fs.readFileSync(path)).replace(/\t/g, function(tab) {
				return '  ';
			});
			var js = haml.optimize(haml.compile(lines));
			var amdjs = 'define(' + js.replace(/^\(|\).call\(this\)$/g, '') + ');';
			var targetPath = path.replace(/^haml|haml$/g, '');
			grunt.file.write('target/js/template/' + targetPath + 'js', amdjs);
		});
	});

	grunt.task.registerTask('compile:coffee', 'compile coffee', function() {
		grunt.file.recurse('coffee', function(path) {
			if(!/\.coffee$/.test(path)) {
				return;
			}
			var lines = '' + fs.readFileSync(path);
			var js = coffee.compile(lines);
			var targetPath = path.replace(/^coffee|coffee$/g, 'js');
			grunt.file.write('target/' + targetPath, js);
		});
	});


	grunt.registerTask('default', ['clean', 'copy:html', 'compile:haml', 'compile:coffee', 'copy:dependencies']);
};
