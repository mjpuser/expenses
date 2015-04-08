var Apollo = require('apollo');
var http = require('http');
var server = new Apollo.instance();
var pipeline = new Apollo.Pipeline();

pipeline.on('handle', function(promise) {
	var entity = this.params.entity;
	var options = {
		method: 'GET',
		hostname: '127.0.0.1',
		port: 8098,
		path: '/search/query/expense' + this.url.search + '&wt=json'
	};
	http.request(options, function(res) {
		var response = this.obj = {
			meta: {},
			results: []
		};
		var data;
		res.on('data', function(chunk) {
			data = JSON.parse('' + chunk);
		});
		res.on('end', function() {
			response.meta.total = data.response.numFound;
			response.results = data.response.docs.map(function(doc) {
				doc.id = doc._yz_rk;
				['_yz_rk', '_yz_id', '_yz_rb', '_yz_rt'].forEach(function(field) {
					delete doc[field];
				});
				return doc;
			});
			this.obj = response;
			promise.resolve();
		});
	}.bind(this)).end();
});

server.get('/api/:entity/search', pipeline);
server.listen();
