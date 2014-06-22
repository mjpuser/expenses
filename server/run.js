var Apollo = require('apollo');
var http = require('http');
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
		var xml = '';
		res.on('data', function(chunk) {
			this.res.write(chunk);
		}.bind(this));
		res.on('end', function() {
			this.res.end();
		}.bind(this));
	}.bind(this)).end();
});

server.get('/api/:entity/search', pipeline);
server.listen();
