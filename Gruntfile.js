var haml = require('haml'),
	coffee = require('coffee-script'),
	cprocess = require('child_process'),
	events = require('events'),
	http = require('http'),
	fs = require('fs');

module.exports = function(grunt) {
	grunt.initConfig({
		buildDir: 'build',
		pkg: grunt.file.readJSON('package.json'),
		watch: {
			haml: {
				files: 'haml/**/*.haml',
				tasks: ['default']
			},
			coffee: {
				files: 'coffee/**/*.coffee',
				tasks: ['default']
			},
			bower: {
				files: 'bower_components/**/*',
				tasks: ['default']
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.task.registerTask('clean', 'Delete build director', function() {
		grunt.file.delete(grunt.config.get('buildDir'));
	});

	grunt.task.registerTask('copy:html', 'Copy html files', function() {
		grunt.file.recurse('html', function(path) {
			grunt.file.copy(path, path.replace(/^html/, grunt.config.get('buildDir')));
		});
	});

	grunt.task.registerTask('copy:dependencies', 'Copy bower dependencies', function() {
		var buildDir = grunt.config.get('buildDir');
		grunt.file.copy('bower_components/requirejs/require.js', buildDir + '/js/lib/require.js');
		grunt.file.copy('bower_components/backbone/backbone.js', buildDir + '/js/lib/backbone.js');
		grunt.file.copy('bower_components/underscore/underscore.js', buildDir + '/js/lib/underscore.js');
		grunt.file.copy('bower_components/jquery/dist/jquery.js', buildDir + '/js/lib/jquery.js');
	});

	grunt.task.registerTask('compile:haml', 'Compile haml templates', function() {
		grunt.file.recurse('haml', function(path) {
			if(!/\.haml$/.test(path)) {
					return;
			}
			var lines = ('' + fs.readFileSync(path)).replace(/\t/g, function(tab) {
				return '  ';
			});
			var js = haml.optimize(haml.compile(lines));
			var amdjs = '\
				define(function(locals) {\
					function html_escape(text) {\
						return (text + "").\
							replace(/&/g, "&amp;").\
							replace(/</g, "&lt;").\
							replace(/>/g, "&gt;").\
							replace(/\"/g, "&quot;");\
					}\
					return function(locals) {\
						with(locals || {}) {\
							try {\
								var _$output;\
								_$output = ' + js + ';\
								return _$output;\
							} catch (e) {\
								return "<pre class=\\"error\\">" + e.stack + "</pre>";\
							}\
						}\
					};\
				});'
			var targetPath = path.replace(/^haml|haml$/g, '');
			grunt.file.write(grunt.config.get('buildDir') + '/js/template/' + targetPath + 'js', amdjs);
		});
	});

	grunt.task.registerTask('compile:coffee', 'Compile coffee', function() {
		grunt.file.recurse('coffee', function(path) {
			if(!/\.coffee$/.test(path)) {
				return;
			}
			var lines = '' + fs.readFileSync(path);
			var js = coffee.compile(lines);
			var targetPath = path.replace(/^coffee|coffee$/g, 'js');
			grunt.file.write(grunt.config.get('buildDir') + '/' + targetPath, js);
		});
	});

	grunt.task.registerTask('config:schema', 'Set schemas', function() {
		var done = this.async();
		cprocess.exec('search-cmd set-schema expense config/riak-schema.erl', function(err, stdout) {
			if(err) {
				console.error(err);
			}
			console.log(stdout);
			done();
		});
	});

	grunt.task.registerTask('drop-bucket', 'Delete a bucket', function() {
		var deleteObj = function(key) {
			var emitter = new events.EventEmitter();
			var options = {
				hostname: 'expenses',
				path: '/db/buckets/expense/keys/' + key,
				method: 'DELETE'
			};
			http.request(options, function(res) {
				emitter.emit('deleted', key);
			}).end();
			return emitter;
		};
		var getKeys = function() {
			var emitter = new events.EventEmitter();
			var options = {
				hostname: 'expenses',
				path: '/db/buckets/expense/keys?keys=true',
				method: 'GET'
			};
			http.request(options, function(res) {
				var body = '';
				res.on('data', function(chunk) {
					body += chunk;
				});
				res.on('end', function() {
					var keys = JSON.parse(body)['keys'];
					keys.forEach(function(key) {
						emitter.emit('key', key);
					});
					emitter.emit('end');
				});
			}).end();
			return emitter;
		};

		var e = getKeys();
		var done = this.async();
		e.on('key', function(key) {
			var e = deleteObj(key);
			e.on('deleted', function(key) {
				console.log('deleted', key);
			});
		});
	});


	grunt.task.registerTask('default', ['clean', 'copy:html', 'compile:haml', 'compile:coffee', 'copy:dependencies', 'watch']);
};
