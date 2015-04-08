#!/bin/bash

# ENABLE RIAK SEARCH!

export RIAK_HOST=127.0.0.1:8098

# create schemas
curl -i -XPUT "$RIAK_HOST/search/schema/expense"   -H'content-type:application/xml'   --data-binary @expense.xml

# create index
# curl -XPUT $RIAK_HOST/search/index/[name of index]
curl -XPUT $RIAK_HOST/search/index/expense -H 'Content-Type: application/json' -d '{"schema":"expense"}'

# setting bucket type
riak-admin bucket-type create map '{"props":{"allow_mult": "false"}}'
riak-admin bucket-type activate map

curl -XPUT $RIAK_HOST/types/map/buckets/expense/props -H 'Content-Type: application/json' -d '{"props":{"search_index":"expense"}}'

# DELETING INDEXES
# disassociate buckets from index:
curl -XPUT $RIAK_HOST/types/map/buckets/expense/props -H 'Content-Type: application/json' -d '{"props":{"search_index":"_dont_index_"}}'


# then delete indexes!
curl -XDELETE $RIAK_HOST/search/index/expense

