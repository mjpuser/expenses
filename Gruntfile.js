var haml = require('haml'),
	coffee = require('coffee-script'),
	cprocess = require('child_process'),
	events = require('events'),
	http = require('http'),
	fs = require('fs');

module.exports = function(grunt) {
	var buildDir = 'build';
	grunt.initConfig({
		buildDir: buildDir,
		pkg: grunt.file.readJSON('package.json'),
		watch: {
			haml: {
				files: 'app/haml/**/*.haml',
				tasks: ['haml:compile']
			},
			coffee: {
				files: 'app/coffee/**/*.coffee',
				tasks: ['coffee:compile']
			},
			bower: {
				files: 'bower_components/**/*',
				tasks: ['copy:dependencies']
			},
			sass: {
				files: 'app/sass/**/*.scss',
				tasks: ['sass']
			}
		},
		sass: {
			dist: {
				files: function() {
					var files = {};
					files[buildDir + '/css/main.css'] = 'app/sass/main.scss';
					return files;
				}.call()
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-sass');

	grunt.task.registerTask('clean', 'Delete build director', function() {
		grunt.file.delete(grunt.config.get('buildDir'));
	});

	grunt.task.registerTask('copy:html', 'Copy html files', function() {
		grunt.file.recurse('app/html', function(path) {
			grunt.file.copy(path, path.replace(/^app\/html/, grunt.config.get('buildDir')));
		});
	});

	grunt.task.registerTask('copy:dependencies', 'Copy bower dependencies', function() {
		var buildDir = grunt.config.get('buildDir');
		grunt.file.copy('bower_components/requirejs/require.js', buildDir + '/js/lib/require.js');
		grunt.file.copy('bower_components/backbone/backbone.js', buildDir + '/js/lib/backbone.js');
		grunt.file.copy('bower_components/underscore/underscore.js', buildDir + '/js/lib/underscore.js');
		grunt.file.copy('bower_components/jquery/dist/jquery.js', buildDir + '/js/lib/jquery.js');
		grunt.file.copy('bower_components/d3/d3.js', buildDir + '/js/lib/d3.js');
		grunt.file.copy('bower_components/nvd3/nv.d3.js', buildDir + '/js/lib/nv.d3.js');
		grunt.file.copy('bower_components/nvd3/nv.d3.css', buildDir + '/css/lib/nv.d3.css');
	});

	grunt.task.registerTask('haml:compile', 'Compile haml templates', function() {
		grunt.file.recurse('app/haml', function(path) {
			if(!/\.haml$/.test(path)) {
					return;
			}
			var lines = ('' + fs.readFileSync(path)).replace(/\t/g, function(tab) {
				return '  ';
			});
			var amdjs = haml.amd(lines);
			var targetPath = path.replace(/^app\/haml|haml$/g, '');
			grunt.file.write(grunt.config.get('buildDir') + '/js/template/' + targetPath + 'js', amdjs);
		});
	});

	grunt.task.registerTask('coffee:compile', 'Compile coffee', function() {
		grunt.file.recurse('app/coffee', function(path) {
			if(!/\.coffee$/.test(path)) {
				return;
			}
			var lines = '' + fs.readFileSync(path);
			try {
				var js = coffee.compile(lines);
			}
			catch(e) {
				console.error(e.message);
				console.error(path, e.location.first_line + ':' + e.location.first_column);
				console.error(lines.split('\n').slice(e.location.first_line-3, e.location.last_line+2).join('\n'));
				throw Error('Could not compile coffee compile');
			}
			var targetPath = path.replace(/^app\/coffee|coffee$/g, 'js');
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
		var queue = [];
		e.on('key', function(key) {
			queue.push(key);
			var e = deleteObj(key);
			e.on('deleted', function(key) {
				queue.splice(queue.indexOf(key), 1);
				console.log('deleted', key);
				if(queue.length == 0) {
					done();
				}
			});
		});
		e.on('end', function() {
			if(queue.length == 0) {
				done();
			}
		});
	});


	grunt.task.registerTask('default', ['clean', 'copy:html', 'haml:compile', 'coffee:compile', 'copy:dependencies', 'sass', 'watch']);
};
