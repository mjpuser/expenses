Simple expenses application

to compile, run grunt
to develop, run grunt watch

everything will compile to the "build" directory.
the directory structure of "build" will be
css/
js/
img/
index.html


To index on riak 1.4.8:
* go to the app.config, and enable riak_search (set it to true)
* set schema for expenses:
* search-cmd set-schema expense config/riak-schema.erl
* search-cmd install expense


Proposal for serializing search query
```
[
	{
		category: {
			range: [1, 10]
		},
		name: {
			value: 'fast',
			required: 'run',
			not: {
				name: {
					value: 'runner'
				}
			}
		},
		not: {
			somthing: 'hi'
		}
	},

		amount:
			phrase:
				value: 'kick a person'
				proximity: 5
			}
		}
	}
]
```
