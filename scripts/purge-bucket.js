var util = require('util');
var Writable = require('stream').Writable;
var Client = require('riak-client');
var http = require('http');
var client = new Client();

var bucket = process.argv[process.argv.indexOf('-b') + 1];
var type = ~process.argv.indexOf('-t') ? process.argv[process.argv.indexOf('-t') + 1] : 'default';

if (bucket == 'node') {
	console.log('Usage: node purge-bucket -t type -b bucket');
	return;
}

var Deleter = function() {
	Deleter.super_.call(this);
};

util.inherits(Deleter, Writable);


Deleter.prototype._write = function(chunk, encoding, callback) {
	var res = JSON.parse('' + chunk);
	res.keys.forEach(function(key) {
		remove(type, bucket, key);
	});
	callback();
};

var options = {
  hostname: '127.0.0.1',
  port: 8098,
  path: '/types/' + type + '/buckets/' + bucket + '/keys?keys=true',
  method: 'GET',
  agent: false
};

console.log('GET', options.path);
var req = http.request(options, function(res) {
  res.setEncoding('utf8');
  res.pipe(new Deleter());
});

req.on('error', function(e) {
  console.log('problem with request: ' + e.message);
});

req.end();



function remove(type, bucket, key) {
	var options = {
	  hostname: '127.0.0.1',
	  port: 8098,
	  path: '/types/' + type + '/buckets/' + bucket + '/keys/' + key,
	  method: 'DELETE',
	  agent: false
	};
	var req = http.request(options, function(res) {
	  console.log(res.statusCode, key);
	});
	req.on('error', function(e) {
		console.log('error', e);
	});
	req.end();
}