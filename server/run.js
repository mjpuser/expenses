var Apollo = require('apollo');
var http = require('http');
var expat = require('node-expat');
var server = new Apollo.instance();
var pipeline = new Apollo.Pipeline();

pipeline.on('handle', function(promise) {
	var entity = this.params.entity;
	var options = {
		method: 'GET',
		hostname: 'expenses',
		path: '/db/solr/' + entity + '/select' + this.url.search
	}
	http.request(options, function(res) {
		var result = null;
		var attr = null;
		var type = null;
		var isInDoc = false, isInField = false;
		var parser = new expat.Parser('UTF-8');
		var response = this.obj = {
			meta: {},
			results: []
		}
		parser.on('startElement', function(name, attrs) {
			if(name == 'result') {
				response.meta.total = parseInt(attrs.numFound);
			}
			if(name == 'doc') {
				isInDoc = true;
				result = {};
				response.results.push(result);
			}
			else if(isInDoc) {
				parser.on('text', function(text) {
					var val = null;
					switch (type) {
						case 'int':
							val = parseInt(text);
							break;
						default:
							val = text;
					}
					result[attr] = val;
					parser.removeAllListeners('text');
				});
				type = name;
				attr = attrs.name;
			}
		});

		parser.on('endElement', function(name) {
			if(name == 'result') {
				promise.resolve();
			}
		});
		res.on('data', function(chunk) {
			try {
				parser.write(chunk);
			}
			catch(e) {
				this.obj = '' + chunk;
				server.respond.bad(this);
			}
		}.bind(this));
	}.bind(this)).end();
});

server.get('/api/:entity/search', pipeline);
server.listen();
